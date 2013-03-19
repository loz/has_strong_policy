[![Build Status](https://travis-ci.org/loz/has_strong_policy.png)](https://travis-ci.org/loz/has_strong_policy)
[![Code Climate](https://codeclimate.com/github/loz/has_strong_policy.png)](https://codeclimate.com/github/loz/has_strong_policy)
[![Dependency Status](https://gemnasium.com/loz/has_strong_policy.png)](https://gemnasium.com/loz/has_strong_policy)
[![Gem Version](https://badge.fury.io/rb/has_strong_policy.png)](http://badge.fury.io/rb/has_strong_policy)

# HasStrongPolicy

Simple delegation for your strong paramters

## Installation

Add this line to your application's Gemfile:

    gem 'has_strong_policy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_strong_policy

## Usage

This gem provides a simple delgation framework for controllers and similar for
using strong parameters in rails.  This allows:

* Shared policy to be applied for multiple similar models (eg. STI)
* Shared policy for the same model in different contexts (e.g. APIs)
* More expressive declaration of paramter securing policies

### Connecting your controller

To use HasStrongPolicy in your rails controller, simply include it, and turn it on:


```ruby
class UserController < ApplicationController
  include HasStrongPolicy::ControllerHelper

  has_strong_policy
end
```

This will provider automatic delgation to a conventionally named ParamsPolicy,
in this case this would be the UserParamsPolicy.

To access the params, simply use the `policy_params` helper, and you'll receive
a clean param hash with all the policy already applied to strong params

You can specify a specifc class to delegate security to by providing `:using`:


```ruby
class SettingsController < ApplicationController
  include HasStrongPolicy::ControllerHelper

  has_strong_policy :using => UserParamsPolicy
end
```

#### Requesting the Params

You request the params filtered through the policy using `policy_params` in
place of regular `params`.  You can also supply options, like so:

```ruby
User.new(policy_params(:as => :admin))
```

### Defining your securing policy

You can a plain old ruby object for your policy object, or use the given policy
definition class to build expressive rulesets.

#### Simple Ruby Interface

Your ruby class should be named conventionally (unless you explicitly specify
with `:using`.  The object simply needs to respond to `:apply` taking the
rails params and an options hash.

```ruby
class UserParamsPolicy
  def apply(params, options)
    acceptable = [:email, :name]
    if options[:role] == :admin
      acceptable << :is_admin
    end
    params.require(:user).permit(acceptable)
  end
end
```

#### Using the Policy class and DSL:

Secures Params provides a DSL based policy class which allows succinct definition
of policies for defaults, specific actions or older accesible :as style roles:

```ruby
class UserParamsPolicy < HasStrongPolicy::Policy
  policy do |p|
    p.required :user
    p.permitted :first_name, :last_name, :dob

    p.on :create do |p|
      p.permitted :email

      p.as :admin do |p|
        p.permitted :is_admin
      end
    end
  end
end
```

Sub definitions inherit the policy from prior ones.  So in the above case, user
has name and dob permitted, but in the create action they can also set email.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
