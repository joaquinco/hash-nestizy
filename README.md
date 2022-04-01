Hash Nestizy
============

Convert a flat hash representation to a nested one. Specifically useful to return easily to handle rails `ActiveModel::Error` in API mode.

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

  def record_invalid(ex)
    render json: HashNestizy.to_nested(ex.record.errors.to_hash), status: :bad_request
  end
end

### Beware of key collisions

Unexpected behaviour might occur on key conflicts. There's no reasonable way
to handle this on a case that fits all use cases.

```ruby
>>> data = {'role' => 'admin', 'role.name' => 'Administrator'}
=> {"role"=>"admin", "role.name"=>"Administrator"}
>>> HashNestizy.to_nested(data)
=> {"role"=>"admin"}
```

You can specify an iterator of `[key, value]` pairs and use the `conflict_override: bool` parameter
to handle key conflicts correctly:

```ruby
>>> data = [['role', 'admin'], ['role.name', 'Administrator']]
=> [["role", "admin"], ["role.name", "Administrator"]]
>>> HashNestizy.to_nested(data, conflict_override: true)
=> {"role"=>{"name": "Administrator"}}

```

## Changelog

- 0.0.3: Initial release
- 0.1.0: Handle conflicts correctly.

## License

[MIT](./LICENSE)
