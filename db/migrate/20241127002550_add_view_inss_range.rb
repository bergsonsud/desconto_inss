class AddViewInssRange < ActiveRecord::Migration[7.2]
    def change
      execute <<-SQL
        DROP VIEW IF EXISTS inss_range_proponent;
      SQL
  
      # Criação da view
      execute <<-SQL
        CREATE VIEW inss_range_proponent AS
        WITH user_ranges AS (
              SELECT 
                  u.id AS user_id,
                  ir.lower_limit,
                  ir.upper_limit
              FROM 
                  users u
              CROSS JOIN 
                  inss_ranges ir
          )
          SELECT
              user_ranges.user_id,
              user_ranges.lower_limit AS range_lower_limit,
              user_ranges.upper_limit AS range_upper_limit,
              COUNT(p.id) AS proponent_count
          FROM
              user_ranges
          LEFT JOIN
              proponents p
          ON
              p.salary BETWEEN user_ranges.lower_limit AND user_ranges.upper_limit
              AND p.user_id = user_ranges.user_id
          GROUP BY
              user_ranges.user_id, user_ranges.lower_limit, user_ranges.upper_limit
          ORDER BY
              user_ranges.user_id, user_ranges.lower_limit;
      SQL
    end
  end
  