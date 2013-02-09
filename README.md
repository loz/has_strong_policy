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

    class UserController < ApplicationController
      include SecuresParams::ControllerHelper

      secures_params
    end

This will provider automatic delgation to a conventionally named ParamsSecurer,
in this case this would be the UserParamsSecurer.

To access the params, simply use the `secured_params` helper, and you'll receive
a clean param hash with all the policy already applied to strong params

You can specify a specifc class to delegate security to by providing `:using`:

    class SettingsController < ApplicationController
      include SecuresParams::ControllerHelper

      secures_params :using => UserParamsSecurer
    end

### Defining your securing policy

WIP

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
