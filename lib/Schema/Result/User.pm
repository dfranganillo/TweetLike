use utf8;
package Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "bigint", is_nullable => 0 },
  "screen_name",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "name",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 40,
  },
  "profile_image_url",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 200,
  },
  "location",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 30,
  },
  "url",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 200,
  },
  "description",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 200,
  },
  "created_at",
  { data_type => "datetime", is_nullable => 0 },
  "followers_count",
  { data_type => "int", default_value => \"null", is_nullable => 1 },
  "friends_count",
  { data_type => "int", default_value => \"null", is_nullable => 1 },
  "statuses_count",
  { data_type => "int", default_value => \"null", is_nullable => 1 },
  "time_zone",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 40,
  },
  "last_update",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "oauth_secret",
  { data_type => "text", is_nullable => 1 },
  "oauth_validator",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("user_id");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-15 20:55:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tddXdWNsdti7xz9kmHx2WQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
