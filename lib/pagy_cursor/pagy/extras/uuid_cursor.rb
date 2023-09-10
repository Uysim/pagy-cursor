require 'pagy_cursor/pagy/cursor'
class Pagy

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_uuid_cursor(collection, vars={})
      pagy = Pagy::Cursor.new(pagy_uuid_cursor_get_vars(collection, vars))
      items =  pagy_uuid_cursor_get_items(collection, pagy, pagy.position)
      pagy.has_more =  pagy_uuid_cursor_has_more?(items, pagy)

      return pagy, items
    end

    def pagy_uuid_cursor_get_vars(collection, vars)
      vars[:arel_table] = collection.arel_table
      vars[:primary_key] = collection.primary_key
      vars[:backend] = 'uuid'
      vars
    end

    def pagy_uuid_cursor_get_items(collection, pagy, position=nil)
      if position.present?
        arel_table = pagy.arel_table

        # If the primary sort key is not "created_at"

        # Select the primary sort key
        # pagy.order should be something like:
        #  [:created_at, :id] or [:foo_column, ..., :created_at, :id]
        primary_sort_key = pagy.order.keys.detect{ |order_key| ![:created_at, :id].include?(order_key.to_sym) } || :created_at

        select_previous_row = arel_table.project(arel_table[primary_sort_key]).
          where(arel_table[pagy.primary_key].eq(position))

        sql_comparation = arel_table[primary_sort_key].
          send(pagy.comparation, select_previous_row).
          or(
            arel_table[primary_sort_key].eq(select_previous_row).
            and(arel_table[pagy.primary_key].send(pagy.comparation, position))
          )

        collection = collection.where(sql_comparation)
      end
      collection.reorder(pagy.order).limit(pagy.items)
    end

    def pagy_uuid_cursor_has_more?(collection, pagy)
      return false if collection.empty?

      next_position = collection.last[pagy.primary_key]
      pagy_uuid_cursor_get_items(collection, pagy, next_position).exists?
    end
  end
end
