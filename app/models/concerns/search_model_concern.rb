module SearchModelConcern
  extend ActiveSupport::Concern

  class_methods do
    def default_search_columns
      columns
        .select { |column| column.type.in?([:string, :text]) }
        .map { |column| "#{table_name}.#{column.name}" }
    end

    def search(q, *columns)
      words = q.to_s.parameterize.split("-")
      columns = default_search_columns if columns.empty?

      return all if words.empty?

      sql_query = words.map.with_index { |_word, index|
        columns.map { |field|
          "(UNACCENT(CAST(#{field} AS TEXT)) ILIKE :w#{index})"
        }.join(" OR ")
      }.map { |e| "(#{e})" }.join(" AND ")

      sql_params = words.map.with_index { |word, index| ["w#{index}".to_sym, "%#{word}%"] }.to_h

      where(sql_query, sql_params)
    end
  end
end
