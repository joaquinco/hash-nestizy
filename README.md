Hash Nestizy
============

Convert a flat hash representation to a nested one. Specifically useful to return easlily to handle rails `ActiveModel::Error` in API mode.

## Examples

```ruby
>>> require 'hash_nestizy'
=> true
>>> errors = { 'name' => 'is required', 'role.name' => 'max be longer than 5' }
=> {"name"=>"is required", "role.name"=>"max be longer than 5"}
>>> HashNestizy.to_nested(errors)
=> {"name"=>"is required", "role"=>{"name"=>"max be longer than 5"}}
```

There's also a handy method to patch it to the `Hash` class.

```ruby
>>> HashNestizy.patch_hash!
=> Hash
>>> { 'name' => 'is required', 'role.name' => 'max be longer than 5' }.nestizy
=> {"name"=>"is required", "role"=>{"name"=>"max be longer than 5"}}
```

You can use it to render `ActiveModel::Error` instances on rails APIs as follow:

```ruby
class ApiController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def record_invalid(error)
    render json: HashNestizy.to_nested(error.to_h), status: :bad_request
  end
end
```
## License

[MIT](./LICENSE)
