# SecuresParams

Simple delegation for your strong paramters

## Installation

Add this line to your application's Gemfile:

    gem 'secures_params'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secures_params

## Usage

This gem provides a simple delgation framework for controllers and similar for
using strong parameters in rails.  This allows:

* Shared policy to be applied for multiple similar models (eg. STI)
* Shared policy for the same model in different contexts (e.g. APIs)
* More expressive declaration of paramter securing policies

### Connecting your controller

To use SecuresParams in your rails controller, simply include it, and turn it on:


    ```ruby
    class UserController < ApplicationController
      include SecuresParams::ControllerHelper

      secures_params
    end
    ```

This will provider automatic delgation to a conventionally named ParamsSecurer,
in this case this would be the UserParamsSecurer.

To access the params, simply use the `secured_params` helper, and you'll receive
a clean param hash with all the policy already applied to strong params

You can specify a specifc class to delegate security to by providing `:using`:


    ```ruby
    class SettingsController < ApplicationController
      include SecuresParams::ControllerHelper

      secures_params :using => UserParamsSecurer
    end
    ```

#### Requesting the Params

You request the params secured through the policy using `secured_params` in
place of regular `params`.  You can also supply options, like so:

    ```ruby
    User.new(secured_params(:as => :admin))
    ```

### Defining your securing policy

You can a plain old ruby object for your policy object, or use the given policy
definition class to build expressive rulesets.

#### Simple Ruby Interface

Your ruby class should be named conventionally (unless you explicitly specify
with `:using`.  The object simply needs to respond to `:secured` taking the
rails params and an options hash.


    ```ruby
    class UserParamsSecurer
      def secured(params, options)
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
    class UserParamsSecurer < SecuresParams::Policy
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
