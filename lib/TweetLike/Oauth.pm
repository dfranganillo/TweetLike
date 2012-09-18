=encoding utf8
=begin HEADER
Valores devueltos por Twitter par aun usuario.

friends_count  
follow_request_sent 
profile_background_image_url_https
profile_sidebar_fill_color  
profile_image_url 
profile_background_color
notifications 
url 
id
is_translator
following
screen_name
location
lang
followers_count
statuses_count
name
description
favourites_count
profile_background_tile
status
listed_count
profile_link_color
contributors_enabled
profile_image_url_https
profile_sidebar_border_color
created_at
utc_offset
verified
profile_background_image_url
show_all_inline_media
protected
default_profile
id_str
profile_text_color
default_profile_image
time_zone
geo_enabled
profile_use_background_image

Deberíamos quedarnos con los valores del id, screen_name, name, location, description, profile_image_url y 
tal vez el ultimo estado 
=end HEADER
=cut
package TweetLike::Oauth;

use 5.010;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
has json => sub {Mojo::JSON->new};
use Data::Dumper;
use utf8;

sub oauth_error
{
#    my $self = shift;
    # Si usamos render* no se cargará ni el layout ni el template!!
#    $self->render_text('Can\'t login');
}

sub oauth
{
    my $self = shift;
    # Obtenemos el proveedor de login (será Twitter siempre, pero más vale prevenir)
    my $provider = $self->param('provider');

    # Si no se puede invocar la función de autenticación mostramos la página de error
    $self->redirect_to('/oauth_error/') 
	unless $self->oauth_callback();
    
    my $oauth = $self->session('oauth');

    # El map, aunque extraño, nos ahorra repetir lo mismo.
    # ($oauth->{access_token}, $oauth->{access_token_secret})
    my $res = $self->oauth_request(
	$oauth->{'oauth_provider'},
	{
	    map {$_ => $oauth->{$_}} qw/access_token access_token_secret/
	}
        );
    
    # Extrae el cuerpo del mensaje o vacío si no tiene
    my $body = $res && $res->content;
    # Si no tiene cuerpo o este tiene etiquetas xml, data es el cuerpo en si mismo (un error), en otro caso tenemos la estructura JSON con los
    # datos del usuario devueltas por Twitter
    my $data = !$body || $body =~ /^\s*<\?xml/ ? $body : $self->json->decode( $body );
    
    # A menos que hayamos recibido un dato correcto no seguimos
    $self->redirect_to('oauth_error') unless defined $data->{'id'};

    # Obtenemos el token Oauth de la llamada del Callback
    my $oauth_token = $self->param('oauth_token');
        
    # Obtenemos el verificador de Oauth de la llamada del Callback
    my $oauth_verifier = $self->param('oauth_verifier');
    
    my $user = $self->db->resultset('User')->by_id($data->{'id'});
    
    if (not defined $user)
    {	
	print "NUEVO USUARIO\n";
    }
    else 
    {	
	print "EL USUARIO YA EXISTE\n";
    }

    $user = $self->db->resultset('User')->update_or_create
	(
	 {
	     user_id => $data->{'id'},
	     oauth_secret => $oauth_token,
	     oauth_validator => $oauth_verifier,
	     screen_name => $data->{'screen_name'},
	     created_at => $data->{'created_at'},
	     name => $data->{'name'},
	     profile_image_url => $data->{'profile_image_url'},
	     location => $data->{'location'},
	     url => $data->{'url'},
	     description => $data->{'description'},
	     followers_count => $data->{'followers_count'},
	     friends_count => $data->{'friends_count'},
	     statuses_count => $data->{'statuses_count'},
	     time_zone => $data->{'time_zone'}
	 }
	);
    
    $self->session('id' => $data->{'id'});
    $self->session('screen_name' => $data->{'screen_name'});
    $self->session('lang' => $data->{'lang'});
    $self->session(expires => time + 604800);

#    print "\nDATA=======================================\n";
#    print $data."\n";
#    print "\nDATA=======================================\n";
    
#    foreach (keys %$data)
#    {
#	print "$_ = ";
#	print "$data->{$_}\n" unless not defined $data->{$_};
#    }

#    $self->render(
#        'data' =>Dumper( $data )
#        );
    $self->redirect_to('/');
}

sub login
{
    my $self = shift;
    my $provider = $self->param('provider');
    my $app = $self->app;
    $self->redirect_to('/oauth_error/') unless
        $self->oauth_login($provider);
#    return;
}

sub logout
{
    my $self = shift;
    $self->session('id' => undef);
    $self->session('screen_name' => undef);
    $self->session('lang' => undef);
    $self->session(expires => 1);
    $self->redirect_to('/');
}

1;
