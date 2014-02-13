# Redistributor

Redistributor seamlessly distributes redis commands between master and slave making it automatic for end users. Besides it adds some nice features as namespacing and some extensions to redis commands.

## Installation

Install the gem as usual:

Add this line to your application's Gemfile:

    gem 'redistributor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redistributor

## Configuration

Redistributor can be configured via a config block:

    $ Redistributor.config do |config|
    $  config.master = {host: 'localhost', port: 6379}
    $  config.slave  = {host: 'localhost', port: 6380}
    $  config.logger = Rails.logger
    $ end


Valid config options are:

* master: Master redis instance. Same options hash as redis-rb. Default to {host: 'localhost', port: 6379}
* slave: Slave redis instance. Same options hash as redis-rb. It will use master settings if not specified.
* logger: Where do you want redistributor to log its output, i.e.: Logger.new(STDOUT) or Rails.logger. Default to Logger.new(STDOUT)

## Usage

Basic usage doesn't vary much from redis-rb:

    $ client = Redistributor::Base.new
    $ client.set "foo", "bar" # this will use master
    $ client.get "foo"        # this will use slave

Besides it add namespacing through the nice redis-namespace gem:

    $ namespaced_client = Redistributor::Base.new :my_namespace
    $ namespaced_client.set "foo", "bar"  # "bar" will be namespaced to "my_namespace"

Multi and pipelined calls are a litle bit peculiar, these will use master by default and the usage varies from redis-rb:

    $ client.multi do |r|
    $   r.set "foo", "bar"
    $   r.set "wadus", "wadus wadus"
    $ end

In this case "r" is the master redis-rb instance. You can use the slave one for read only queries too:

    $ client.multi(:slave) do |r|
    $   r.get "foo"
    $   r.get "wadus"
    $ end

Be careful with this since the redis-rb clients are directly exposed within these calls.

### Redis extensions

Right now the only extension impleted is zadd_with_score which works as zadd but without the need to specify the score which get calculated automatically by calculating a hash value.

    $ client.zadd_with_score "ord_set", "hello"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Kudos to <https://github.com/ryanlecompte/redis_failover> which served as inspiration for this gem.