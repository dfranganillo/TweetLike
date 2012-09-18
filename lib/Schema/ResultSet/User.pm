package Schema::ResultSet::User;

use Modern::Perl;
use base 'DBIx::Class::ResultSet';

sub by_id {
    return shift->find({user_id => pop});
}

sub by_name {
    return shift->find({screen_name => pop});
}

sub by_id_or_name {
    my ($self, $param) = @_;
    return $param =~ /^\d+$/ ? $self->by_id($param) : $self->by_name($param);
}

1;
