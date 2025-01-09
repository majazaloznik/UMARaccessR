-- ============================================================================
-- Function definition get_unit_from_vintage
-- Description: Retrieves unit name for given vintage ID
-- ============================================================================

CREATE OR REPLACE FUNCTION test_platform.get_unit_from_vintage(p_vintage_id bigint)
RETURNS TABLE (name character varying) AS $$
BEGIN
    RETURN QUERY
    SELECT u.name
    FROM test_platform.vintage v
    JOIN test_platform.series s ON v.series_id = s.id
    JOIN test_platform.unit u ON s.unit_id = u.id
    WHERE v.id = p_vintage_id::bigint;  -- Explicit cast
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function definition get_unit_from_series
-- Description: Retrieves unit name for given series ID
-- ============================================================================

CREATE OR REPLACE FUNCTION test_platform.get_unit_from_series(p_series_id bigint)
RETURNS TABLE (name character varying) AS $$
BEGIN
    RETURN QUERY
    SELECT u.name
    FROM test_platform.unit u
    JOIN test_platform.series s ON s.unit_id = u.id
    WHERE s.id = p_series_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_series_name_from_vintage
-- Description: Retrieves series name for given vintage ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_series_name_from_vintage(p_vintage_id bigint)
RETURNS TABLE (name_long character varying) AS $$
BEGIN
    RETURN QUERY
    SELECT s.name_long
    FROM test_platform.vintage v
    JOIN test_platform.series s ON v.series_id = s.id
    WHERE v.id = p_vintage_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_series_name_from_series
-- Description: Retrieves series name for given series ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_series_name_from_series(p_series_id bigint)
RETURNS TABLE (name_long character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT s.name_long
   FROM test_platform.series s
   WHERE s.id = p_series_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_series_name_from_series_code
-- Description: Retrieves series name for given series code
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_series_name_from_series_code(p_series_code text)
RETURNS TABLE (name_long character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT s.name_long
   FROM test_platform.series s
   WHERE s.code = p_series_code;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_table_name_from_vintage
-- Description: Retrieves table name for given vintage ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_table_name_from_vintage(p_vintage_id bigint)
RETURNS TABLE (name character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT t.name
   FROM test_platform.vintage v
   JOIN test_platform.series s ON v.series_id = s.id
   JOIN test_platform."table" t ON s.table_id = t.id
   WHERE v.id = p_vintage_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_table_name_from_series
-- Description: Retrieves table name for given series ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_table_name_from_series(p_series_id bigint)
RETURNS TABLE (name character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT t.name
   FROM test_platform.series s
   JOIN test_platform."table" t ON s.table_id = t.id
   WHERE s.id = p_series_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_interval_from_vintage
-- Description: Retrieves interval ID for given vintage ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_interval_from_vintage(p_vintage_id bigint)
RETURNS TABLE (interval_id character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT s.interval_id
   FROM test_platform.vintage v
   JOIN test_platform.series s ON v.series_id = s.id
   WHERE v.id = p_vintage_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_interval_from_series
-- Description: Retrieves interval ID for given series ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_interval_from_series(p_series_id bigint)
RETURNS TABLE (interval_id character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT s.interval_id
   FROM test_platform.series s
   WHERE s.id = p_series_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_vintage_from_series
-- Description: Retrieves most recent or date-specific vintage ID for given series ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_vintage_from_series(
   p_series_id bigint,
   p_date_valid timestamp DEFAULT NULL
)
RETURNS TABLE (id int) AS $$
BEGIN
   RETURN QUERY
   SELECT v.id
   FROM test_platform.vintage v
   WHERE v.series_id = p_series_id
   AND (p_date_valid IS NULL OR v.published < p_date_valid)
   ORDER BY v.published DESC
   LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_vintage_from_series_code
-- Description: Retrieves most recent or date-specific vintage ID for given series code
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_vintage_from_series_code(
   p_series_code text,
   p_date_valid timestamp DEFAULT NULL
)
RETURNS TABLE (id int) AS $$
BEGIN
   RETURN QUERY
   SELECT v.id
   FROM test_platform.vintage v
   JOIN test_platform.series s ON v.series_id = s.id
   WHERE s.code = p_series_code
   AND (p_date_valid IS NULL OR v.published < p_date_valid)
   ORDER BY v.published DESC
   LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_data_points_from_vintage
-- Description: Retrieves all data points (period_id, value) for given vintage ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_data_points_from_vintage(p_vintage_id bigint)
RETURNS TABLE (
   period_id character varying,
   value numeric
) AS $$
BEGIN
   RETURN QUERY
   SELECT dp.period_id, dp.value
   FROM test_platform.data_points dp
   WHERE dp.vintage_id = p_vintage_id
   ORDER BY dp.period_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_data_points_from_series
-- Description: Retrieves all data points for most recent or specific vintage of a series
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_data_points_from_series(
    p_series_id bigint,
    p_date_valid timestamp DEFAULT NULL
)
RETURNS TABLE (
    period_id character varying,
    value numeric
) AS $$
BEGIN
    RETURN QUERY
    SELECT dp.period_id, dp.value
    FROM test_platform.vintage v
    JOIN test_platform.data_points dp ON dp.vintage_id = v.id
    WHERE v.series_id = p_series_id
    AND (p_date_valid IS NULL OR v.published < p_date_valid)
    AND v.id = (
        SELECT id
        FROM test_platform.vintage v2
        WHERE v2.series_id = p_series_id
        AND (p_date_valid IS NULL OR v2.published < p_date_valid)
        ORDER BY published DESC
        LIMIT 1
    )
    ORDER BY dp.period_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_date_published_from_vintage
-- Description: Retrieves publication timestamp for given vintage ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_date_published_from_vintage(p_vintage_id bigint)
RETURNS TABLE (published timestamp with time zone) AS $$
BEGIN
   RETURN QUERY
   SELECT v.published AT TIME ZONE 'CET'
   FROM test_platform.vintage v
   WHERE v.id = p_vintage_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_last_period_from_vintage
-- Description: Retrieves most recent period with non-null value for given vintage
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_last_period_from_vintage(p_vintage_id bigint)
RETURNS TABLE (period_id character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT dp.period_id
   FROM test_platform.data_points dp
   WHERE dp.vintage_id = p_vintage_id
   AND dp.value IS NOT NULL
   ORDER BY dp.period_id DESC
   LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_source_code_from_source_name
-- Description: Retrieves source ID for given source name
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_source_code_from_source_name(p_source_name text)
RETURNS TABLE (id integer) AS $$
BEGIN
   RETURN QUERY
   SELECT s.id
   FROM test_platform.source s
   WHERE s.name = p_source_name;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_table_id_from_table_code
-- Description: Retrieves table ID for given table code
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_table_id_from_table_code(p_table_code text)
RETURNS TABLE (id bigint) AS $$
BEGIN
   RETURN QUERY
   SELECT t.id
   FROM test_platform."table" t
   WHERE t.code = p_table_code;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_tab_dim_id_from_table_id_and_dimension
-- Description: Retrieves table dimension ID for given table id and dimension
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_tab_dim_id_from_table_id_and_dimension(
    p_table_id integer,
    p_dimension text
)
RETURNS TABLE (id bigint) AS $$
BEGIN
    RETURN QUERY
    SELECT td.id
    FROM test_platform.table_dimensions td
    WHERE td.table_id = p_table_id
    AND td.dimension = p_dimension;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_unit_id_from_unit_name
-- Description: Retrieves unit ID for given unit name
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_unit_id_from_unit_name(p_unit_name text)
RETURNS TABLE (id integer) AS $$
BEGIN
   RETURN QUERY
   SELECT u.id
   FROM test_platform.unit u
   WHERE u.name = p_unit_name;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_series_ids_from_table_id
-- Description: Retrieves all series IDs for given table ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_series_ids_from_table_id(p_table_id integer)
RETURNS TABLE (id bigint) AS $$
BEGIN
   RETURN QUERY
   SELECT s.id
   FROM test_platform.series s
   WHERE s.table_id = p_table_id
   ORDER BY s.id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_dimension_levels_from_table_id
-- Description: Retrieves all dimension levels for a given table ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_dimension_levels_from_table_id(p_table_id integer)
RETURNS TABLE (
   tab_dim_id bigint,
   dimension character varying,
   level_value character varying,
   level_text character varying
) AS $$
BEGIN
   RETURN QUERY
   SELECT
       td.id as tab_dim_id,
       td.dimension,
       dl.level_value,
       dl.level_text
   FROM test_platform.table_dimensions td
   JOIN test_platform.dimension_levels dl ON dl.tab_dim_id = td.id
   WHERE td.table_id = p_table_id
   ORDER BY td.dimension, dl.level_value;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_series_id_from_series_code
-- Description: Retrieves series ID for given series code
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_series_id_from_series_code(p_series_code text)
RETURNS TABLE (id bigint) AS $$
BEGIN
   RETURN QUERY
   SELECT s.id
   FROM test_platform.series s
   WHERE s.code = p_series_code;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_max_category_id_for_source
-- Description: Retrieves maximum category ID for given source ID
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_max_category_id_for_source(p_source_id integer)
RETURNS TABLE (max_id integer) AS $$
BEGIN
   RETURN QUERY
   SELECT COALESCE(MAX(c.id), 0)  -- Return 0 if no categories exist
   FROM test_platform.category c
   WHERE c.source_id = p_source_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_initials_from_author_name
-- Description: Retrieves author initials for given author name
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_initials_from_author_name(p_author_name text)
RETURNS TABLE (initials character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT a.initials
   FROM test_platform.umar_authors a
   WHERE a.name = p_author_name;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_email_from_author_initials
-- Description: Retrieves author email for given author initials
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_email_from_author_initials(p_initials text)
RETURNS TABLE (email character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT a.email
   FROM test_platform.umar_authors a
   WHERE a.initials = p_initials;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- Function: get_level_value_from_text
-- Description: Retrieves dimension level value for given dimension ID and level text
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_level_value_from_text(
   p_tab_dim_id bigint,
   p_level_text character varying
)
RETURNS TABLE (level_value character varying) AS $$
BEGIN
   RETURN QUERY
   SELECT dl.level_value
   FROM test_platform.dimension_levels dl
   WHERE dl.tab_dim_id = p_tab_dim_id
   AND dl.level_text = p_level_text;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_time_dimension_from_table_code
-- Description: Retrieves time dimension name for given table code
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_time_dimension_from_table_code(p_table_code text)
RETURNS TABLE (dimension character varying) AS $$
BEGIN
    RETURN QUERY
    SELECT td.dimension
    FROM test_platform.table_dimensions td
    JOIN test_platform."table" t ON td.table_id = t.id
    WHERE t.code = p_table_code
    AND td.is_time = true;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: get_last_publication_date_from_table_id
-- Description: Retrieves latest publication date for any series in given table
-- ============================================================================
CREATE OR REPLACE FUNCTION test_platform.get_last_publication_date_from_table_id(p_table_id integer)
RETURNS TABLE (published timestamp) AS $$
BEGIN
   RETURN QUERY
   SELECT DISTINCT v.published
   FROM test_platform.vintage v
   JOIN test_platform.series s ON v.series_id = s.id
   WHERE s.table_id = p_table_id
   ORDER BY v.published DESC;
END;
$$ LANGUAGE plpgsql;
