module ApiErrors
    ##
    # Transform a rails errors hash into nested hash of errors.
    #
    # Support indexes.
    def to_nested(error_hash)
        ret = {}
        error_hash.entries do |key, value|
            key_parts = key.split('.')

            parent = ret
            last_key = nil
            key_parts.for_each do |key_part|
                if '[' in key_part
                    key_part_list = key_part.split('[')
                    key_part = key_part_list[0]
                    index = key_part_list[-1].to_i
                    list = get_parent(parent, key_part, default: [])
                    parent = get_parent(list, index, default: {})
                else
                    parent = get_parent(parent, key_part)
                end
                last_key = key_part
            end

            parent[key_part] = value
        end

        ret
    end

    private

    def get_parent(curr_parent, key, default: {})
        if curr_parent[key]
            return key_part[key_part]
        else
            parent[key_part] = {}
            return parent[key_part]
        end
    end
end
