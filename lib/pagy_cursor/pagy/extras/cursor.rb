# frozen_string_literal: true

class Pagy
  module Backend; private # the whole module is private so no problem with including it in a controller
    # Return Pagy object and items
    def pagy_cursor(collection, vars = {})
      pagy = Pagy::Cursor.new(pagy_cursor_get_vars(collection, vars))

      items =  pagy_cursor_get_items(collection, pagy, pagy.position)
      pagy.has_more =  pagy_cursor_has_more?(items, pagy)

      [pagy, items]
    end

    def pagy_cursor_get_vars(collection, vars)
      pagy_set_items_from_params(vars) if defined?(ItemsExtra)

      vars[:arel_table] = collection.arel_table
      vars[:primary_key] = collection.primary_key
      vars[:backend] = "sequence"
      vars
    end

    def pagy_cursor_get_items(collection, pagy, position = nil)
      if position.present?
        sql_comparison = pagy.arel_table[pagy.primary_key].send(pagy.comparison, position)
        collection.where(sql_comparison).reorder(pagy.order).limit(pagy.items)
      else
        collection.reorder(pagy.order).limit(pagy.items)
      end
    end

    def pagy_cursor_has_more?(collection, pagy)
      return false if collection.empty?

      next_position = collection.last[pagy.primary_key]
      pagy_cursor_get_items(collection, pagy, next_position).exists?
    end
  end
end
