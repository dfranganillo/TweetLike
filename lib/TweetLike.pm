package TweetLike;

use Mojo::Base 'Mojolicious';
use Schema;

use 5.010;                             # 
use open ':std', ':utf8';              # STDIN, STDOUT, STDERR en UTF8
use utf8;                              # Codigo en UTF8

# Self ahora tiene una función schema
has schema => sub {
    return Schema->connect('dbi:SQLite:users.db');
};

#use Twitter_fetcher;

#use Mojo::ByteStream 'b';




sub startup 
{    
    my $self = shift;
    
    # Añadimos un helper _db_ para poder acceder a la BBDD directamente
    $self->helper( db => sub{ $self->app->schema});
    
    # Add Host helper (cant seem to find another way to do this?)
    $self->helper
	(
	 Host => sub 
	 {
	     my $self = shift;
	     my $is_secure = $self->tx->req->is_secure;
	     my $protocol = $is_secure ? 'https' : 'http';
	     my $host = $self->tx->req->headers->host;
	     my $language = $self->{stash}->{i18n}->languages;
	     return "$protocol://$host/$language";
	 }
	);
		   
    $self->sessions->default_expiration(604800);
    
    $ENV{'OAUTH_DEBUG'} = 1;
    $ENV{'MOJO_I18N_DEBUG'} = 1;
    $self->attr('conf' => sub {do 'app.conf'});

    $self->plugin('o_auth', $self->conf);

    $self->plugin('I18N', {
	namespace => 'I18N',
	default => 'es', 
	support_url_langs => [qw(es en)]
		  });
    
    our $config->{languages} = ['es', 'en'];

    my $r = $self->routes;
     
    $self->plugins->on
	(
	 after_static_dispatch => sub 
	 {
	     my ($self, $c) = @_;
	     # We don't want to parse static files urls
	     return if $self->res->code;
	     
	     if (my $path = $self->tx->req->url->path) {
		my $part = $path->parts->[0];
		my $code = $self->session('ln');
		
		if ($part && grep { $part eq $_ } @{$config->{languages}}) {
		    shift @{$path->parts};
		    $self->app->log->debug("Found language $part in url");
		    $self->stash->{i18n}->languages($part);
		    $self->session(ln => $part);
		}
		elsif ($code && grep { $code eq $_ } @{$config->{languages}}) {
		    $self->app->log->debug("Found language $code in session");
		    $self->stash->{i18n}->languages($code);
		}
		else
		{
		    $self->stash->{i18n}->languages('es');
		    $self->session(ln => 'es');
		}
	     }
	 }
	);
   


    # GET (Route) TO (Controller#sub) NAME (TEMPLATE) 
    $r->get('/')->to('TweetLike#index')->name('index');    
    $r->get('user')->to('TweetLike#show');    
    $r->post('/user')->to('TweetLike#show')->name('show');
    $r->get('/user/:name')->to('TweetLike#show_user')->name('show_user');
    $r->get('/about')->to('TweetLike#about')->name('about');
    $r->get('/donate')->to('TweetLike#donate')->name('donate');
    $r->get ('/oauth_error')->to('Oauth#oauth_error')->name('oauth_error');
    $r->get ('/login/:provider')->to('Oauth#login')->name('login');
    $r->get ('/logout/')->to('Oauth#logout');
    $r->get('/oauth/:provider')->to('Oauth#oauth')->name('oauth');
}

1;


