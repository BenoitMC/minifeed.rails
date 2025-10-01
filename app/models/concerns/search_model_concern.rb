module SearchModelConcern
  extend ActiveSupport::Concern

  class_methods do
    def default_search_columns
      columns
        .select { |column| column.type.in?(%i[string text]) }
        .map { |column| "#{table_name}.#{column.name}" }
    end

    def search(query, columns = default_search_columns, unaccent: true)
      words = query.to_s.parameterize.split("-")

      return all if words.empty?

      sql_query = words.map.with_index do |_word, index|
        columns.map do |field|
          field = "UNACCENT(#{field})" if unaccent
          "(#{field} ILIKE :w#{index})"
        end.join(" OR ")
      end.map { |e| "(#{e})" }.join(" AND ") # rubocop:disable Style/MultilineBlockChain

      sql_params = words.map.with_index { |word, index| [:"w#{index}", "%#{word}%"] }.to_h

      where(sql_query, sql_params)
    end
  end
end
