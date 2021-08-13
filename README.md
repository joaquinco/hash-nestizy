Hash Nestizy
============

Convert a flat hash representation to a nested one. Specifically useful to return easlily to handle rails `ActiveRecord::Error` in API mode.

## Examples

```ruby
>>> require 'hash_nestizy'
=> true
>>> errors = { 'name' => 'is required', 'role.name' => 'max be longer than 5' }
=> {"name"=>"is required", "role.name"=>"max be longer than 5"}
irb(main):008:0> HashNestizy.to_nested(errors)
=> {"name"=>"is required", "role"=>{"name"=>"max be longer than 5"}}
```

There's also a handy method to patch it to the `Hash` class.

```ruby
>>> HashNestizy.patch_hash!
=> Hash
>>> { 'name' => 'is required', 'role.name' => 'max be longer than 5' }.nestizy
=> {"name"=>"is required", "role"=>{"name"=>"max be longer than 5"}}
```

## License

[MIT](./LICENSE)
