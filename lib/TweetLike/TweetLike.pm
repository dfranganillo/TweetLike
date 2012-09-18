package TweetLike::TweetLike;

# Vamos a ser un controlador de Mojo
use Mojo::Base 'Mojolicious::Controller';
# Capa sobre la api de Twitter
use Net::Twitter;

sub index
{

}

sub about 
{
    my $self = shift;
    $self->redirect_to('/');
    
}
sub show
{
    my $self = shift;
    my $name = $self->param('username');

    if ($name eq '' )
    {
        $self->render_text("User not found");
    }
    else
    {
        $self->redirect_to('show_user', name=>$name);
    }
}

sub donate
{
    my $self = shift;
    $self->redirect_to('/') if (not defined $self->session('id'));
    $self->render();
}

sub show_user
{
    my $self = shift;

    my $timeline = get_user_timeline($self);

    $self->render(timeline => $timeline);
}


sub get_user_timeline
{
    my $self  = shift;
    my $username = $self->param('name');
    my $user_id = $self->session('id');

    if (not defined $user_id)
    {
	print "Not logged in\n";
	$self->redirect_to('/');
	return;
    }
        
    my $user = $self->db->resultset('User')->by_id($user_id);

    my $consumer_key = $self->app->conf->{'consumer_key'};
    
    my $consumer_secret = $self->app->conf->{'consumer_secret'};

    my $access_token = $user->oauth_validator;
    
    my $access_secret = $user->oauth_secret;	
    
    print "Fetching tweets for user ".$username."\n";
    
    my $nt = Net::Twitter->new(
	traits => ['API::REST'],
	consumer_key => $consumer_key,
	consumer_secret => $consumer_secret,
	access_token => $access_token,
	access_secret => $access_secret,
	count => 200	
	);
    my $results = undef;
    eval 
    {
	$results = $nt->user_timeline({
	    include_entities=>1,
	    screen_name=>$username,
	    include_rts=>1});
    };
    if ($@)
    {
	print "No existe el usuario\n";
    }

    return $results;

}

1;
