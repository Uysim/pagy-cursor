class Pagy

  class Cursor < Pagy
    attr_reader :before, :after, :arel_table, :primary_key, :order, :comparation, :position
    attr_accessor :has_more
    alias_method :has_more?, :has_more

    def initialize(vars)
      @vars = DEFAULT.merge(vars.delete_if{|_,v| v.nil? || v == '' })
      @items = vars[:items] || DEFAULT[:items]
      @before = vars[:before]
      @after = vars[:after]
      @arel_table = vars[:arel_table]
      @primary_key = vars[:primary_key]
      @reorder = vars[:order] || {}

      if @before.present? and @after.present?
        raise(ArgumentError, 'before and after can not be both mentioned')
      end

      if vars[:backend] == 'uuid'

        @comparation = 'lt' # arel table less than
        @position = @before
        @order = @reorder.merge({ :created_at => :desc , @primary_key => :desc })

        if @after.present? || (@reorder.present? && @reorder.values.uniq.first.to_sym == :asc)
          @comparation = 'gt' # arel table greater than
          @position = @after
          @order = @reorder.merge({ :created_at => :asc , @primary_key => :asc })
        end
      else

        @comparation = 'lt'
        @position = @before
        @order = @reorder.merge({ @primary_key => :desc })

        if @after.present? || (@reorder.present? && @reorder.values.uniq.first.to_sym == :asc)
          @comparation = 'gt'
          @position = @after
          @order = @reorder.merge({ @primary_key => :asc })
        end
      end
    end
  end
 end
