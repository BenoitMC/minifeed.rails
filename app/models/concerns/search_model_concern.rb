module SearchModelConcern
  extend ActiveSupport::Concern

  class_methods do
    def default_search_columns
      columns
        .select { |column| column.type.in?([:string, :text]) }
        .map { |column| "#{table_name}.#{column.name}" }
    end

    def search(q, columns = default_search_columns, unaccent: true)
      words = q.to_s.parameterize.split("-")

      return all if words.empty?

      sql_query = words.map.with_index { |_word, index|
        columns.map { |field|
          field = "UNACCENT(#{field})" if unaccent
          "(#{field} ILIKE :w#{index})"
        }.join(" OR ")
      }.map { |e| "(#{e})" }.join(" AND ")

      sql_params = words.map.with_index { |word, index| [:"w#{index}", "%#{word}%"] }.to_h

      where(sql_query, sql_params)
    end
  end
end
