h1. Configatron

Configatron makes configuring your applications and scripts incredibly easy. No longer is a there a need to use constants or global variables. Now you can use a simple and painless system to configure your life. And, because it's all Ruby, you can do any crazy thing you would like to!

h2. Installation

Installation of Configatron is easy, as it is just a RubyGem:

<pre><code>
  $ sudo gem install configatron
</code></pre>

If you'd like to live on the bleedin' edge you can install the development version from GitHub:

<pre><code>
  $ sudo gem install markbates-configatron --source=http://gems.github.com
</code></pre>

Once installed you just need to require it:

<pre><code>
  require 'configatron'
</code></pre>

h2. Examples

h3. Simple

<pre><code>
  configatron.email = 'me@example.com'
  configatron.database_url = "postgres://localhost/mack_framework_rocks"
</code></pre>

Now, anywhere in your code you can do the following:

<pre><code>
  configatron.email # => "me@example.com"
  configatron.database_url # => "postgres://localhost/mack_framework_rocks"
</code></pre>

Viola! Simple as can be.

Now you're saying, what if I want to have a 'default' set of options, but then override them later, based on other information? Simple again. Let's use our above example. We've configured our @database_url@ option to be @postgres://localhost/mack_framework_rocks@. The problem with that is that is our production database url, not our development url. Fair enough, all you have to do is redeclare it:

<pre><code>
  configatron.database_url = "postgres://localhost/mack_framework_rocks_development"
</code></pre>

becomes:

<pre><code>
  configatron.email # => "me@example.com"
  configatron.database_url # => "postgres://localhost/mack_framework_rocks_development"
</code></pre>

Notice how our other configuration parameters haven't changed? Cool, eh?

h3. Hash/YAML

You can configure configatron from a hash as well (this is really only useful in testing or for data driven configuration, it's not recommended for actual configuration):

<pre><code>
  configatron.configure_from_hash({:email => {:pop => {:address => 'pop.example.com', :port => 110}}, :smtp => {:address => 'smtp.example.com'}})

  configatron.email.pop.address # => 'pop.example.com'
  configatron.email.pop.port # => 110
  # and so on...
</code></pre>

h4. YAML

Support for YAML has been deprecated and will be removed in version 2.9 of Configatron. Please switch to Ruby based configuration of Configatron. Trust me, it's a lot nicer and easier to use. Why would you _not_ want to?

h3. Namespaces

The question that should be on your lips is what I need to have namespaced configuration parameters. It's easy! Configatron allows you to create namespaces.

<pre><code>
  configatron.website_url = "http://www.mackframework.com"
  configatron.email.pop.address = "pop.example.com"
  configatron.email.pop.port = 110
  configatron.email.smtp.address = "smtp.example.com"
  configatron.email.smtp.port = 25
</code></pre>

becomes:

<pre><code>
  configatron.email.pop.address # => "pop.example.com"
  configatron.email.smtp.address # => "smtp.example.com"
  configatron.website_url # => "http://www.mackframework.com"
</code></pre>

Configatron allows you to nest namespaces to your hearts content! Just keep going, it's that easy.

Of course you can update a single parameter n levels deep as well:

<pre><code>
  configatron.email.pop.address = "pop2.example.com"

  configatron.email.pop.address # => "pop2.example.com"
  configatron.email.smtp.address # => "smtp.example.com"
</code></pre>

h3. Temp Configurations

Sometimes in testing, or other situations, you want to temporarily change some settings. You can do this with the @temp@ method:

<pre><code>
  configatron.one = 1
  configatron.letters.a = 'A'
  configatron.letters.b = 'B'
  configatron.temp do
    configatron.letters.b = 'bb'
    configatron.letters.c = 'c'
    configatron.one # => 1
    configatron.letters.a # => 'A'
    configatron.letters.b # => 'bb'
    configatron.letters.c # => 'c'
  end
  configatron.one # => 1
  configatron.letters.a # => 'A'
  configatron.letters.b # => 'B'
  configatron.letters.c # => nil
</code></pre>

You can also pass in an optional Hash to the @temp@:

<pre><code>
  configatron.one = 1
  configatron.letters.a = 'A'
  configatron.letters.b = 'B'
  configatron.temp(:letters => {:b => 'bb', :c => 'c'}) do
    configatron.one == 1
    configatron.letters.a # => 'A'
    configatron.letters.b # => 'bb'
    configatron.letters.c # => 'c'
  end
  configatron.one == 1
  configatron.letters.a # => 'A'
  configatron.letters.b # => 'B'
  configatron.letters.c # => nil
</code></pre>

h3. Delayed and Dynamic Configurations

There are times when you want to refer to one configuration setting in another configuration setting. Let's look at a fairly contrived example:

<pre><code>
  configatron.memcached.servers = ['127.0.0.1:11211']
  configatron.page_caching.servers = configatron.memcached.servers
  configatron.object_caching.servers = configatron.memcached.servers

  if Rails.env == 'production'
    configatron.memcached.servers = ['192.168.0.1:11211']
    configatron.page_caching.servers = configatron.memcached.servers
    configatron.object_caching.servers = configatron.memcached.servers
  elsif Rails.env == 'staging'
    configatron.memcached.servers = ['192.168.0.2:11211']
    configatron.page_caching.servers = configatron.memcached.servers
    configatron.object_caching.servers = configatron.memcached.servers
  end
</code></pre>

Now, we could've written that slightly differently, but it helps to illustrate the point. With Configatron you can create <code>Delayed</code> and <code>Dynamic</code> settings.

h4. Delayed

With <code>Delayed</code> settings execution of the setting doesn't happen until the first time it is executed.

<pre><code>
  configatron.memcached.servers = ['127.0.0.1:11211']
  configatron.page_caching.servers = Configatron::Delayed.new {configatron.memcached.servers}
  configatron.object_caching.servers = Configatron::Delayed.new {configatron.memcached.servers}

  if Rails.env == 'production'
    configatron.memcached.servers = ['192.168.0.1:11211']
  elsif Rails.env == 'staging'
    configatron.memcached.servers = ['192.168.0.2:11211']
  end
</code></pre>

Execution occurs once and after that the result of that execution is returned. So in our case the first time someone calls the setting <code>configatron.page_caching.servers</code> it will find the <code>configatron.memcached.servers</code> setting and return that. After that point if the <code>configatron.memcached.servers</code> setting is changed, the original settings are returned by <code>configatron.page_caching.servers</code>.

h4. Dynamic

<code>Dynamic</code> settings are very similar to <code>Delayed</code> settings, but with one big difference. Every time you call a <code>Dynamic</code> setting is executed. Take this example:

<pre><code>
  configatron.current.time = Configatron::Dynamic.new {Time.now}
</code></pre>

Each time you call <code>configatron.current.time</code> it will return a new value to you. While this seems a bit useless, it is pretty useful if you have ever changing configurations.

h3. Misc.

Even if parameters haven't been set, you can still call them, but you'll get a @Configatron::Store@ object back. The Configatron::Store class, however, will respond true to @.nil?@ if there are no parameters configured on it.

<pre><code>
  configatron.i.dont.exist.nil? # => true
  configatron.i.dont.exist # => Configatron::Store
</code></pre>

If you want to get back an actual @nil@ then you can use the @retrieve@ method:

<pre><code>
  configatron.i.do.exist = [:some, :array]
  configatron.i.dont.retrieve(:exist, nil) # => nil
  configatron.i.do.retrieve(:exist, :foo) # => [:some, :array]
</code></pre>

You can set 'default' values for parameters. If there is already a setting, it won't be replaced. This is useful if you've already done your 'configuration' and you call a library, that needs to have parameters set. The library can set its defaults, without worrying that it might have overridden your custom settings.

<pre><code>
  configatron.set_default(:name, 'Mark Bates')
  configatron.name # => 'Mark Bates'
  configatron.set_default(:name, 'Me')
  configatron.name # => 'Mark Bates'
</code></pre>

Enjoy!

h2. Contributors

* Mark Bates
* Kurtis Rainbolt-Greene
* Rob Sanheim
* Cody Maggard
* Jean-Denis Vauguet
* Torsten Schönebaum
* Mat Brown
* Simon Menke
* chatgris
* Gleb Pomykalov
* Casper Gripenberg
* mattelacchiato
* Artiom Diomin
* Tim Riley
* Rick Fletcher
* joe miller
* Brandon Dimcheff
* Dan Pickett
* Josh Nichols