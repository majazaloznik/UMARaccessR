-- ============================================================================
-- Tests for get_category_id_from_name
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_source_id integer := 1;
    v_category_id integer;
    v_result integer;
BEGIN
    RAISE NOTICE 'Starting get_category_id_from_name tests...';

    -- Create test category
    INSERT INTO platform.category (id, name, source_id)
    VALUES (9999, 'Test Category Name', v_source_id);

    -- Remember the inserted ID
    v_category_id := 9999;

    -- Test 1: Basic retrieval
    SELECT id INTO v_result
    FROM platform.get_category_id_from_name('Test Category Name', v_source_id);

    ASSERT v_result = v_category_id,
        format('Category ID should be %s but got %s', v_category_id, v_result);

    -- Test 2: Non-existent category name
    ASSERT NOT EXISTS (
        SELECT 1 FROM platform.get_category_id_from_name('Nonexistent Category', v_source_id)
    ), 'Should return empty for non-existent category name';

    -- Test 3: Wrong source ID
    ASSERT NOT EXISTS (
        SELECT 1 FROM platform.get_category_id_from_name('Test Category Name', v_source_id + 1)
    ), 'Should return empty when source ID does not match';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_data_points_from_series
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_unit_id int;
    v_table_id bigint;
    v_series_id bigint;
    v_vintage_id1 int;
    v_vintage_id2 int;
    v_result record;
BEGIN
    RAISE NOTICE 'Starting get_data_points_from_series tests...';

    -- Create prerequisites
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    INSERT INTO platform.unit (name)
    VALUES ('test_unit')
    RETURNING id INTO v_unit_id;

    INSERT INTO platform.series (table_id, name_long, code, unit_id)
    VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
    RETURNING id INTO v_series_id;


    INSERT INTO platform.vintage (series_id, published)
    VALUES (v_series_id, '2024-01-01 10:00:00'::timestamp)
    RETURNING id INTO v_vintage_id1;

    INSERT INTO platform.data_points (vintage_id, period_id, value)
    VALUES
        (v_vintage_id1, '2024Q1', 100.5),
        (v_vintage_id1, '2024Q2', 101.2);

    INSERT INTO platform.vintage (series_id, published)
    VALUES (v_series_id, '2024-01-02 10:00:00'::timestamp)
    RETURNING id INTO v_vintage_id2;

    INSERT INTO platform.data_points (vintage_id, period_id, value)
    VALUES
        (v_vintage_id2, '2024Q1', 100.7),
        (v_vintage_id2, '2024Q2', 101.4),
        (v_vintage_id2, '2024Q3', 102.0);

    -- Test 1: Get most recent vintage's data
    FOR v_result IN
        SELECT * FROM platform.get_data_points_from_series(v_series_id)
    LOOP
        ASSERT v_result.value IS NOT NULL,
            'Value should not be null in most recent vintage';
    END LOOP;

    -- Test 2: Get data valid at specific date
    FOR v_result IN
        SELECT * FROM platform.get_data_points_from_series(
            v_series_id, '2024-01-02 09:00:00'::timestamp)
    LOOP
        ASSERT v_result.period_id IN ('2024Q1', '2024Q2'),
            'Should only return data from first vintage';
    END LOOP;

    -- Test 3: Check ordering
    ASSERT EXISTS (
        SELECT 1
        FROM (
            SELECT period_id,
                   LAG(period_id) OVER (ORDER BY period_id) as prev_period
            FROM platform.get_data_points_from_series(v_series_id)
        ) t
        WHERE prev_period IS NULL OR prev_period < period_id
    ), 'Results should be ordered by period_id';

    -- Test 4: Non-existent series
    ASSERT NOT EXISTS (
        SELECT 1 FROM platform.get_data_points_from_series(-1)
    ), 'Should return empty for non-existent series';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;



-- ============================================================================
-- Tests for get_data_points_from_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id int;
   v_result record;
BEGIN
   RAISE NOTICE 'Starting get_data_points_from_vintage tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;



   INSERT INTO platform.data_points (vintage_id, period_id, value)
   VALUES
       (v_vintage_id, '2024Q1', 100.5),
       (v_vintage_id, '2024Q2', 101.2),
       (v_vintage_id, '2024Q3', 102.7);

   -- Test 1: Check data retrieval and ordering
   FOR v_result IN
       SELECT * FROM platform.get_data_points_from_vintage(v_vintage_id)
   LOOP
       ASSERT v_result.period_id IS NOT NULL,
           'Period ID should not be null';
       ASSERT v_result.value IS NOT NULL,
           'Value should not be null';
   END LOOP;

   -- Test 2: Check ordering
   ASSERT EXISTS (
       SELECT 1
       FROM (
           SELECT period_id,
                  LAG(period_id) OVER (ORDER BY period_id) as prev_period
           FROM platform.get_data_points_from_vintage(v_vintage_id)
       ) t
       WHERE prev_period IS NULL OR prev_period < period_id
   ), 'Results should be ordered by period_id';

   -- Test 3: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_data_points_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;


-- ============================================================================
-- Tests for get_date_published_from_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id int;
   v_result timestamp with time zone;
   v_test_timestamp timestamp with time zone;
BEGIN
   RAISE NOTICE 'Starting get_date_published_from_vintage tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Set specific timestamp for testing
   v_test_timestamp := '2024-01-01 10:00:00 CET'::timestamp with time zone;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, v_test_timestamp)
   RETURNING id INTO v_vintage_id;

   -- Test 1: Basic retrieval with timezone
   SELECT published INTO v_result
   FROM platform.get_date_published_from_vintage(v_vintage_id);

   ASSERT v_result = v_test_timestamp,
       format('Published timestamp should be %s but got %s',
              v_test_timestamp, v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_date_published_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;


-- ============================================================================
-- Tests for get_dimension_id_from_table_id_and_dimension
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_dimension_id bigint;
   v_result bigint;
   v_count integer;
BEGIN
   RAISE NOTICE 'Starting get_dimension_id_from_table_id_and_dimension tests...';

   -- Create test table
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create dimension
   INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Test 1: Basic retrieval
   SELECT COUNT(*) INTO v_count
   FROM platform.get_dimension_id_from_table_id_and_dimension(
       v_table_id, 'test_dimension'
   );

   ASSERT v_count = 1,
       'Should return exactly one dimension';

   SELECT id INTO v_result
   FROM platform.get_dimension_id_from_table_id_and_dimension(
       v_table_id, 'test_dimension'
   );

   ASSERT v_result = v_dimension_id,
       format('Expected ID %s but got %s', v_dimension_id, v_result);

   -- Test 2: Non-existent table
   SELECT COUNT(*) INTO v_count
   FROM platform.get_dimension_id_from_table_id_and_dimension(-1, 'test_dimension');

   ASSERT v_count = 0,
       'Should return empty for non-existent table';

   -- Test 3: Non-existent dimension
   SELECT COUNT(*) INTO v_count
   FROM platform.get_dimension_id_from_table_id_and_dimension(
       v_table_id, 'nonexistent'
   );

   ASSERT v_count = 0,
       'Should return empty for non-existent dimension';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_dimension_levels_from_table_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_dimension_id bigint;
   v_result record;
   v_count integer;
BEGIN
   RAISE NOTICE 'Starting get_dimension_levels_from_table_id tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test dimension
   INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Insert test dimension levels
   INSERT INTO platform.dimension_levels (tab_dim_id, level_value, level_text)
   VALUES
       (v_dimension_id, 'A', 'Level A'),
       (v_dimension_id, 'B', 'Level B'),
       (v_dimension_id, 'C', 'Level C');

   -- Test 1: Count results
   SELECT COUNT(*) INTO v_count
   FROM platform.get_dimension_levels_from_table_id(v_table_id);

   ASSERT v_count = 3,
       format('Should return 3 levels but got %s', v_count);

   -- Test 2: Check ordering
   FOR v_result IN
       SELECT * FROM platform.get_dimension_levels_from_table_id(v_table_id)
   LOOP
       ASSERT v_result.dimension = 'test_dimension',
           'Wrong dimension name';
       ASSERT v_result.tab_dim_id = v_dimension_id,
           'Wrong dimension id';
       ASSERT v_result.level_value IS NOT NULL,
           'Level value should not be null';
       ASSERT v_result.level_text IS NOT NULL,
           'Level text should not be null';
   END LOOP;

   -- Test 3: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_dimension_levels_from_table_id(-1)
   ), 'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_dimension_position_from_table
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_table_id integer;
    v_position integer;
BEGIN
    RAISE NOTICE 'Starting get_dimension_position_from_table tests...';

    -- Create prerequisites
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create multiple dimensions in specific order
    INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
    VALUES
        (v_table_id, 'time_dim', true),       -- Should be ignored (is_time = true)
        (v_table_id, 'region', false),        -- Position 1
        (v_table_id, 'category', false),      -- Position 2
        (v_table_id, 'subcategory', false);   -- Position 3

    -- Test 1: Get position of middle dimension
    SELECT platform.get_dimension_position_from_table(v_table_id, 'category')
    INTO v_position;

    ASSERT v_position = 2,
        format('Category should be position 2 but got %s', v_position);

    -- Test 2: Get position of first dimension
    SELECT platform.get_dimension_position_from_table(v_table_id, 'region')
    INTO v_position;

    ASSERT v_position = 1,
        format('Region should be position 1 but got %s', v_position);

    -- Test 3: Non-existent dimension
    SELECT platform.get_dimension_position_from_table(v_table_id, 'nonexistent')
    INTO v_position;

    ASSERT v_position IS NULL,
        'Should return null for non-existent dimension';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_dimensions_from_table_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_table_id integer;
    v_result RECORD;
    v_count integer;
BEGIN
    RAISE NOTICE 'Starting get_dimensions_from_table_id tests...';

    -- Create test table
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create multiple dimensions
    INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
    VALUES
        (v_table_id, 'time_dim', true),
        (v_table_id, 'region', false),
        (v_table_id, 'category', false);

    -- Test 1: Count dimensions
    SELECT COUNT(*) INTO v_count
    FROM platform.get_dimensions_from_table_id(v_table_id);

    ASSERT v_count = 3,
        format('Should return 3 dimensions but got %s', v_count);

    -- Test 2: Check each returned row
    FOR v_result IN
        SELECT * FROM platform.get_dimensions_from_table_id(v_table_id)
    LOOP
        ASSERT v_result.table_id = v_table_id,
            'Table ID should match input';
        ASSERT v_result.dimension IS NOT NULL,
            'Dimension name should not be null';
        ASSERT v_result.is_time IS NOT NULL,
            'is_time should not be null';
    END LOOP;

    -- Test 3: Non-existent table
    SELECT COUNT(*) INTO v_count
    FROM platform.get_dimensions_from_table_id(-1);

    ASSERT v_count = 0,
        'Should return empty for non-existent table';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_email_from_author_initials
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_email_from_author_initials tests...';

   -- Create test author
   INSERT INTO platform.umar_authors (name, initials, email)
   VALUES ('Test Author', 'TA', 'test@example.com');

   -- Test 1: Basic retrieval
   SELECT email INTO v_result
   FROM platform.get_email_from_author_initials('TA');

   ASSERT v_result = 'test@example.com',
       format('Author email should be test@example.com but got %s', v_result);

   -- Test 2: Non-existent initials
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_email_from_author_initials('XX')
   ), 'Should return empty for non-existent initials';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests get_initials_from_author_name
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_author_initials character varying;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_initials_from_author_name tests...';

   -- Create test author
   INSERT INTO platform.umar_authors (name, initials, email)
   VALUES ('Test Author', 'TA', 'test@example.com');

   -- Test 1: Basic retrieval
   SELECT initials INTO v_result
   FROM platform.get_initials_from_author_name('Test Author');

   ASSERT v_result = 'TA',
       format('Author initials should be TA but got %s', v_result);

   -- Test 2: Non-existent author
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_initials_from_author_name('Nonexistent Author')
   ), 'Should return empty for non-existent author';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_interval_from_series
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_interval_from_series tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   -- Create series with known interval
   INSERT INTO platform.series (table_id, name_long, code, unit_id, interval_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id, 'M')
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT interval_id INTO v_result
   FROM platform.get_interval_from_series(v_series_id);

   ASSERT v_result = 'M',
       format('Interval ID should be "M" but got %s', v_result);

   -- Test 2: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_interval_from_series(-1)
   ), 'Should return empty for non-existent series';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_interval_from_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id int;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_interval_from_vintage tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   -- Create series with known interval
   INSERT INTO platform.series (table_id, name_long, code, unit_id, interval_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id, 'M')
   RETURNING id INTO v_series_id;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;

   -- Test 1: Basic retrieval
   SELECT interval_id INTO v_result
   FROM platform.get_interval_from_vintage(v_vintage_id);

   ASSERT v_result = 'M',
       format('Interval ID should be "M" but got %s', v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_interval_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_last_period_from_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id int;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_last_period_from_vintage tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;


   INSERT INTO platform.data_points (vintage_id, period_id, value)
   VALUES
       (v_vintage_id, '2024Q1', 100.5),
       (v_vintage_id, '2024Q2', 101.2),
       (v_vintage_id, '2024Q3', NULL),
       (v_vintage_id, '2024Q4', NULL);

   -- Test 1: Get last non-null period
   SELECT period_id INTO v_result
   FROM platform.get_last_period_from_vintage(v_vintage_id);

   ASSERT v_result = '2024Q2',
       format('Last period should be 2024Q2 but got %s', v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_last_period_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_last_publication_date_from_table_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_series_id bigint;
   v_result_count integer;
BEGIN
   RAISE NOTICE 'Starting get_last_publication_date_from_table_id tests...';

   -- Create test table
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test series
   INSERT INTO platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series', 'TS1')
   RETURNING id INTO v_series_id;

   -- Create multiple vintages with different dates
   INSERT INTO platform.vintage (series_id, published)
   VALUES
       (v_series_id, '2024-01-01 10:00:00'::timestamp),
       (v_series_id, '2024-01-02 10:00:00'::timestamp),
       (v_series_id, '2024-01-03 10:00:00'::timestamp);

   -- Test 1: Check we get correct number of distinct dates
   SELECT COUNT(*) INTO v_result_count
   FROM (
       SELECT DISTINCT published
       FROM platform.get_last_publication_date_from_table_id(v_table_id)
   ) t;

   ASSERT v_result_count = 1,
       format('Should find 1 distinct dates but found %s', v_result_count);

   -- Test 2: Check ordering
   ASSERT EXISTS (
       SELECT 1
       FROM (
           SELECT published,
                  LAG(published) OVER (ORDER BY published DESC) as prev_date
           FROM platform.get_last_publication_date_from_table_id(v_table_id)
       ) t
       WHERE prev_date IS NULL OR published < prev_date
   ), 'Results should be ordered by published date DESC';

   -- Test 3: Non-existent table
   SELECT COUNT(*) INTO v_result_count
   FROM platform.get_last_publication_date_from_table_id(-1);

   ASSERT v_result_count = 0,
       'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_level_value_from_text
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_dimension_id bigint;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_level_value_from_text tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create dimension
   INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Create dimension level
   INSERT INTO platform.dimension_levels (tab_dim_id, level_value, level_text)
   VALUES (v_dimension_id, 'VALUE_A', 'Text for A');

   -- Test 1: Basic retrieval
   SELECT level_value INTO v_result
   FROM platform.get_level_value_from_text(v_dimension_id, 'Text for A');

   ASSERT v_result = 'VALUE_A',
       format('Level value should be VALUE_A but got %s', v_result);

   -- Test 2: Non-existent level text
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_level_value_from_text(v_dimension_id, 'Nonexistent')
   ), 'Should return empty for non-existent level text';

   -- Test 3: Non-existent dimension ID
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_level_value_from_text(-1, 'Text for A')
   ), 'Should return empty for non-existent dimension ID';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_levels_from_dimension_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_table_id integer;
    v_dimension_id integer;  -- Changed from bigint to integer
    v_result RECORD;
    v_count integer;
BEGIN
    RAISE NOTICE 'Starting get_levels_from_dimension_id tests...';

    -- Create prerequisites
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create dimension
    INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
    VALUES (v_table_id, 'test_dimension', false)
    RETURNING id INTO v_dimension_id;

    -- Create dimension levels
    INSERT INTO platform.dimension_levels (tab_dim_id, level_value, level_text)
    VALUES
        (v_dimension_id, 'A', 'Level A'),
        (v_dimension_id, 'B', 'Level B'),
        (v_dimension_id, 'C', 'Level C');

    -- Test 1: Count results
    SELECT COUNT(*) INTO v_count
    FROM platform.get_levels_from_dimension_id(v_dimension_id);

    ASSERT v_count = 3,
        format('Should return 3 levels but got %s', v_count);

    -- Test 2: Check ordering
    FOR v_result IN
        SELECT * FROM platform.get_levels_from_dimension_id(v_dimension_id)
    LOOP
        ASSERT v_result.tab_dim_id = v_dimension_id,
            'Dimension ID should match input';
        ASSERT v_result.level_value IS NOT NULL,
            'Level value should not be null';
        ASSERT v_result.level_text IS NOT NULL,
            'Level text should not be null';
    END LOOP;

    -- Test 3: Non-existent dimension ID
    SELECT COUNT(*) INTO v_count
    FROM platform.get_levels_from_dimension_id(-1);

    ASSERT v_count = 0,
        'Should return empty for non-existent dimension ID';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_max_category_id_for_source
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_source_id integer;
   v_result integer;
BEGIN
   RAISE NOTICE 'Starting get_max_category_id_for_source tests...';

   -- Create test source
   INSERT INTO platform.source (id, name, name_long, url)
   VALUES (100, 'TEST_SOURCE', 'Test Source', 'http://test.com')
   RETURNING id INTO v_source_id;

   -- Create multiple categories
   INSERT INTO platform.category (id, name, source_id)
   VALUES
       (1, 'Category 1', v_source_id),
       (2, 'Category 2', v_source_id),
       (5, 'Category 5', v_source_id);

   -- Test 1: Get max ID
   SELECT max_id INTO v_result
   FROM platform.get_max_category_id_for_source(v_source_id);

   ASSERT v_result = 5,
       format('Maximum category ID should be 5 but got %s', v_result);

   -- Test 2: Non-existent source
   SELECT max_id INTO v_result
   FROM platform.get_max_category_id_for_source(-1);

   ASSERT v_result = 0,
       'Should return 0 for source with no categories';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_non_time_dimensions_from_table_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_table_id integer;
    v_time_dim_id bigint;
    v_non_time_dim_id bigint;
    v_result RECORD;
    v_count integer;
BEGIN
    RAISE NOTICE 'Starting get_non_time_dimensions_from_table_id tests...';

    -- Create test table
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create both time and non-time dimensions
    INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
    VALUES
        (v_table_id, 'time_dimension', true),
        (v_table_id, 'region', false),
        (v_table_id, 'category', false);

    -- Test 1: Count non-time dimensions
    SELECT COUNT(*) INTO v_count
    FROM platform.get_non_time_dimensions_from_table_id(v_table_id);

    ASSERT v_count = 2,
        format('Should return 2 non-time dimensions but got %s', v_count);

    -- Test 2: Check each returned row
    FOR v_result IN
        SELECT * FROM platform.get_non_time_dimensions_from_table_id(v_table_id)
    LOOP
        ASSERT v_result.dimension IN ('region', 'category'),
            format('Unexpected dimension name: %s', v_result.dimension);
        ASSERT v_result.id IS NOT NULL,
            'Dimension ID should not be null';
    END LOOP;

    -- Test 3: Non-existent table
    SELECT COUNT(*) INTO v_count
    FROM platform.get_non_time_dimensions_from_table_id(-1);

    ASSERT v_count = 0,
        'Should return empty for non-existent table';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests get_series_from_table_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_unit_id integer;
   v_result RECORD;
   v_count integer;
BEGIN
   RAISE NOTICE 'Starting get_series_from_table_id tests...';

   -- Create test table
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test unit
   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   -- Create multiple series
   INSERT INTO platform.series (table_id, name_long, unit_id, code, interval_id, live)
   VALUES
       (v_table_id, 'Test Series 1', v_unit_id, 'TS1', 'M', true),
       (v_table_id, 'Test Series 2', v_unit_id, 'TS2', 'Q', true);

   -- Test 1: Count series
   SELECT COUNT(*) INTO v_count
   FROM platform.get_series_from_table_id(v_table_id);

   ASSERT v_count = 2,
       format('Should return 2 series but got %s', v_count);

   -- Test 2: Check each returned row
   FOR v_result IN
       SELECT * FROM platform.get_series_from_table_id(v_table_id)
   LOOP
       ASSERT v_result.table_id = v_table_id,
           'Table ID should match input';
       ASSERT v_result.name_long IS NOT NULL,
           'Name should not be null';
       ASSERT v_result.code IS NOT NULL,
           'Code should not be null';
   END LOOP;

   -- Test 3: Non-existent table
   SELECT COUNT(*) INTO v_count
   FROM platform.get_series_from_table_id(-1);

   ASSERT v_count = 0,
       'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;


-- ============================================================================
-- Tests for get_series_id_from_series_code
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_series_id bigint;
   v_result bigint;
BEGIN
   RAISE NOTICE 'Starting get_series_id_from_series_code tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test series
   INSERT INTO platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series', 'TEST_SERIES')
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM platform.get_series_id_from_series_code('TEST_SERIES');

   ASSERT v_result = v_series_id,
       format('Series ID should be %s but got %s', v_series_id, v_result);

   -- Test 2: Non-existent series code
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_series_id_from_series_code('NONEXISTENT')
   ), 'Should return empty for non-existent series code';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_series_ids_from_table_id
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_series_id1 bigint;
   v_series_id2 bigint;
   v_result record;
   v_count integer;
BEGIN
   RAISE NOTICE 'Starting get_series_ids_from_table_id tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create multiple test series
   INSERT INTO platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series 1', 'TS1')
   RETURNING id INTO v_series_id1;

   INSERT INTO platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series 2', 'TS2')
   RETURNING id INTO v_series_id2;

   -- Test 1: Count results
   SELECT COUNT(*) INTO v_count
   FROM platform.get_series_ids_from_table_id(v_table_id);

   ASSERT v_count = 2,
       format('Should return 2 series but got %s', v_count);

   -- Test 2: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_series_ids_from_table_id(-1)
   ), 'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_series_name_from_series
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_series_name_from_series tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series Long Name', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT name_long INTO v_result
   FROM platform.get_series_name_from_series(v_series_id);

   ASSERT v_result = 'Test Series Long Name',
       format('Series name should be "Test Series Long Name" but got %s', v_result);

   -- Test 2: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_series_name_from_series(-1)
   ), 'Should return empty for non-existent series';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_series_name_from_series_code
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_series_name_from_series_code tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series Long Name', 'TEST_SERIES', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT name_long INTO v_result
   FROM platform.get_series_name_from_series_code('TEST_SERIES');

   ASSERT v_result = 'Test Series Long Name',
       format('Series name should be "Test Series Long Name" but got %s', v_result);

   -- Test 2: Non-existent code
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_series_name_from_series_code('NONEXISTENT')
   ), 'Should return empty for non-existent series code';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_series_name_from_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_unit_id int;
    v_table_id bigint;
    v_series_id bigint;
    v_vintage_id int;
    v_result character varying;
BEGIN
    RAISE NOTICE 'Starting get_series_name_from_vintage tests...';

    -- Create prerequisites
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    INSERT INTO platform.unit (name)
    VALUES ('test_unit')
    RETURNING id INTO v_unit_id;

    INSERT INTO platform.series (table_id, name_long, code, unit_id)
    VALUES (v_table_id, 'Test Series Long Name', 'TS1', v_unit_id)
    RETURNING id INTO v_series_id;

    INSERT INTO platform.vintage (series_id, published)
    VALUES (v_series_id, CURRENT_TIMESTAMP)
    RETURNING id INTO v_vintage_id;

    -- Test 1: Basic retrieval
    SELECT name_long INTO v_result
    FROM platform.get_series_name_from_vintage(v_vintage_id);

    ASSERT v_result = 'Test Series Long Name',
        format('Series name should be "Test Series Long Name" but got %s', v_result);

    -- Test 2: Non-existent vintage
    ASSERT NOT EXISTS (
        SELECT 1 FROM platform.get_series_name_from_vintage(-1)
    ), 'Should return empty for non-existent vintage';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_source_code_from_source_name
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_source_id int;
   v_result int;
BEGIN
   RAISE NOTICE 'Starting get_source_code_from_source_name tests...';

   -- Create test source
   INSERT INTO platform.source (id, name, name_long, url)
   VALUES (100, 'TEST_SOURCE', 'Test Source Long Name', 'http://test.com')
   RETURNING id INTO v_source_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM platform.get_source_code_from_source_name('TEST_SOURCE');

   ASSERT v_result = v_source_id,
       format('Source ID should be %s but got %s', v_source_id, v_result);

   -- Test 2: Non-existent source
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_source_code_from_source_name('NONEXISTENT')
   ), 'Should return empty for non-existent source';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_tab_dim_id_from_table_id_and_dimension
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id integer;
   v_dimension_id bigint;
   v_result bigint;
BEGIN
   RAISE NOTICE 'Starting get_tab_dim_id_from_table_id_and_dimension tests...';

   -- Create test table
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test dimension
   INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM platform.get_tab_dim_id_from_table_id_and_dimension(v_table_id, 'test_dimension');

   ASSERT v_result = v_dimension_id,
       format('Dimension ID should be %s but got %s', v_dimension_id, v_result);

   -- Test 2: Non-existent dimension
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_tab_dim_id_from_table_id_and_dimension(v_table_id, 'nonexistent')
   ), 'Should return empty for non-existent dimension';

   -- Test 3: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_tab_dim_id_from_table_id_and_dimension(-1, 'test_dimension')
   ), 'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_table_id_from_table_code
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_table_id bigint;
   v_result bigint;
BEGIN
   RAISE NOTICE 'Starting get_table_id_from_table_code tests...';

   -- Create test table
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM platform.get_table_id_from_table_code('TEST_TABLE');

   ASSERT v_result = v_table_id,
       format('Table ID should be %s but got %s', v_table_id, v_result);

   -- Test 2: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_table_id_from_table_code('NONEXISTENT')
   ), 'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Test for get_table_info function
-- ============================================================================
BEGIN;

DO $$
DECLARE
    v_table_id INTEGER;
    v_result RECORD;
    v_test_code VARCHAR := 'TEST_GTI_' || floor(random() * 10000)::TEXT;
BEGIN
    RAISE NOTICE 'Starting tests for get_table_info...';

    -- Create test table
    RAISE NOTICE 'Creating test table...';
    INSERT INTO platform.table (code, name, source_id, url, description, notes, update, keep_vintage)
    VALUES (
        v_test_code,
        'Test Get Table Info',
        1,
        'http://example.com/test',
        'Test description',
        '{"note": "test note"}'::json,
        true,
        false
    )
    RETURNING id INTO v_table_id;

    RAISE NOTICE 'Created test table with ID: %', v_table_id;

    -- Test retrieving the table info
    SELECT * FROM platform.get_table_info(v_table_id) INTO v_result;

    -- Verify results
    ASSERT v_result.id = v_table_id,
        format('Expected ID %s, got %s', v_table_id, v_result.id);

    ASSERT v_result.code = v_test_code,
        format('Expected code %s, got %s', v_test_code, v_result.code);

    ASSERT v_result.name = 'Test Get Table Info',
        format('Expected name "Test Get Table Info", got %s', v_result.name);

    ASSERT v_result.source_id = 1,
        format('Expected source_id 1, got %s', v_result.source_id);

    ASSERT v_result.description = 'Test description',
        format('Expected description "Test description", got %s', v_result.description);

    ASSERT v_result.update = true,
        format('Expected update true, got %s', v_result.update);

    ASSERT v_result.keep_vintage = false,
        format('Expected keep_vintage false, got %s', v_result.keep_vintage);

    RAISE NOTICE 'Basic retrieval test passed';

    -- Test with non-existent table ID
    PERFORM * FROM platform.get_table_info(999999);
    -- Should return empty result set but not error
    RAISE NOTICE 'Non-existent ID test passed';

    RAISE NOTICE 'All tests for get_table_info passed!';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;
-- ============================================================================
-- Tests for get_table_name_from_series
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_table_name_from_series tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table Name', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT name INTO v_result
   FROM platform.get_table_name_from_series(v_series_id);

   ASSERT v_result = 'Test Table Name',
       format('Table name should be "Test Table Name" but got %s', v_result);

   -- Test 2: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_table_name_from_series(-1)
   ), 'Should return empty for non-existent series';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;
-- ============================================================================
-- Tests for get_table_name_from_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id int;
   v_result character varying;
BEGIN
   RAISE NOTICE 'Starting get_table_name_from_vintage tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table Name', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;

   -- Test 1: Basic retrieval
   SELECT name INTO v_result
   FROM platform.get_table_name_from_vintage(v_vintage_id);

   ASSERT v_result = 'Test Table Name',
       format('Table name should be "Test Table Name" but got %s', v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_table_name_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_tables_from_source
-- ============================================================================
BEGIN;

DO $$
DECLARE
    v_table_id1 BIGINT;
    v_table_id2 BIGINT;
    v_table_id3 BIGINT;
    v_count INTEGER;
    v_test_code1 VARCHAR := 'TEST_SRC_T_' || floor(random() * 10000)::TEXT;
    v_test_code2 VARCHAR := 'TEST_SRC_F_' || floor(random() * 10000)::TEXT;
    v_test_code3 VARCHAR := 'TEST_SRC_T2_' || floor(random() * 10000)::TEXT;
BEGIN
    RAISE NOTICE 'Starting tests for get_tables_from_source...';

    -- Create test tables with different source_id and update values
    RAISE NOTICE 'Creating test tables...';

    -- Table with source_id = 1, update = TRUE
    INSERT INTO platform.table (code, name, source_id, update)
    VALUES (v_test_code1, 'Test Source 1 Update True', 1, TRUE)
    RETURNING id INTO v_table_id1;

    -- Table with source_id = 1, update = FALSE
    INSERT INTO platform.table (code, name, source_id, update)
    VALUES (v_test_code2, 'Test Source 1 Update False', 1, FALSE)
    RETURNING id INTO v_table_id2;

    -- Table with source_id = 2, update = TRUE
    INSERT INTO platform.table (code, name, source_id, update)
    VALUES (v_test_code3, 'Test Source 2 Update True', 2, TRUE)
    RETURNING id INTO v_table_id3;

    RAISE NOTICE 'Created test tables with IDs: %, %, %', v_table_id1, v_table_id2, v_table_id3;

    -- Test 1: Retrieving tables with source_id = 1, update = TRUE
    SELECT COUNT(*) INTO v_count
    FROM platform.get_tables_from_source(1, TRUE)
    WHERE id IN (v_table_id1, v_table_id2, v_table_id3);

    ASSERT v_count = 1,
        format('Expected 1 table with source_id = 1 and update = TRUE, got %s', v_count);
    RAISE NOTICE 'Test 1 PASSED: Got % table with source_id = 1 and update = TRUE', v_count;

    -- Test 2: Retrieving tables with source_id = 1, update = NULL (any update value)
    SELECT COUNT(*) INTO v_count
    FROM platform.get_tables_from_source(1, NULL)
    WHERE id IN (v_table_id1, v_table_id2, v_table_id3);

    ASSERT v_count = 2,
        format('Expected 2 tables with source_id = 1 and any update value, got %s', v_count);
    RAISE NOTICE 'Test 2 PASSED: Got % tables with source_id = 1 and any update value', v_count;

    -- Test 3: Retrieving tables with source_id = NULL (any source), update = TRUE
    SELECT COUNT(*) INTO v_count
    FROM platform.get_tables_from_source(NULL, TRUE)
    WHERE id IN (v_table_id1, v_table_id2, v_table_id3);

    ASSERT v_count = 2,
        format('Expected 2 tables with any source_id and update = TRUE, got %s', v_count);
    RAISE NOTICE 'Test 3 PASSED: Got % tables with any source_id and update = TRUE', v_count;

    -- Test 4: Retrieving all tables (NULL source_id, NULL update)
    SELECT COUNT(*) INTO v_count
    FROM platform.get_tables_from_source(NULL, NULL)
    WHERE id IN (v_table_id1, v_table_id2, v_table_id3);

    ASSERT v_count = 3,
        format('Expected 3 tables with any source_id and any update value, got %s', v_count);
    RAISE NOTICE 'Test 4 PASSED: Got % tables with any source_id and any update value', v_count;

    RAISE NOTICE 'All tests for updated get_tables_from_source passed!';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;

ROLLBACK;

-- ============================================================================
-- Tests for get_tables_with_keep_vintage
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_table_id1 bigint;
    v_table_id2 bigint;
    v_count integer;
BEGIN
    RAISE NOTICE 'Starting get_tables_with_keep_vintage tests...';

    -- Create test tables with different keep_vintage values
    INSERT INTO platform.table (code, name, source_id, keep_vintage)
    VALUES ('TEST_KEEP_T', 'Test Keep Vintage True', 1, TRUE)
    RETURNING id INTO v_table_id1;

    INSERT INTO platform.table (code, name, source_id, keep_vintage)
    VALUES ('TEST_KEEP_F', 'Test Keep Vintage False', 1, FALSE)
    RETURNING id INTO v_table_id2;

    -- Test 1: Get tables with keep_vintage = TRUE
    SELECT COUNT(*) INTO v_count
    FROM platform.get_tables_with_keep_vintage(TRUE)
    WHERE id = v_table_id1;

    ASSERT v_count = 1,
        format('Should return one table with keep_vintage = TRUE, but got %s', v_count);

    -- Test 2: Get tables with keep_vintage = FALSE
    SELECT COUNT(*) INTO v_count
    FROM platform.get_tables_with_keep_vintage(FALSE)
    WHERE id = v_table_id2;

    ASSERT v_count = 1,
        format('Should return one table with keep_vintage = FALSE, but got %s', v_count);

    -- Test 3: Check specific values
    ASSERT EXISTS (
        SELECT 1
        FROM platform.get_tables_with_keep_vintage(TRUE)
        WHERE code = 'TEST_KEEP_T'
    ), 'Should return the correct table with keep_vintage = TRUE';

    ASSERT EXISTS (
        SELECT 1
        FROM platform.get_tables_with_keep_vintage(FALSE)
        WHERE code = 'TEST_KEEP_F'
    ), 'Should return the correct table with keep_vintage = FALSE';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_time_dimension_from_table_code
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_table_id integer;
    v_result character varying;
BEGIN
    RAISE NOTICE 'Starting get_time_dimension_from_table_code tests...';

    -- Create test table
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create dimensions (time and non-time)
    INSERT INTO platform.table_dimensions (table_id, dimension, is_time)
    VALUES
        (v_table_id, 'time_dim', true),
        (v_table_id, 'other_dim', false);

    -- Test 1: Basic retrieval
    SELECT dimension INTO v_result
    FROM platform.get_time_dimension_from_table_code('TEST_TABLE');

    ASSERT v_result = 'time_dim',
        format('Time dimension should be time_dim but got %s', v_result);

    -- Test 2: Non-existent table
    ASSERT NOT EXISTS (
        SELECT 1 FROM platform.get_time_dimension_from_table_code('NONEXISTENT')
    ), 'Should return empty for non-existent table';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;


-- ============================================================================
-- Tests get_unit_from_series
-- ============================================================================
BEGIN;
DO $$
DECLARE
    v_unit_id int;
    v_table_id bigint;
    v_series_id bigint;
    v_result character varying;
BEGIN
    RAISE NOTICE 'Starting get_unit_from_series tests...';

    -- Setup test data
    INSERT INTO platform.table (code, name, source_id, url)
    VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create unit
    INSERT INTO platform.unit (name)
    VALUES ('test_unit')
    RETURNING id INTO v_unit_id;

    -- Create series
    INSERT INTO platform.series (table_id, name_long, code, unit_id)
    VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
    RETURNING id INTO v_series_id;

    -- Test 1: Basic retrieval
    SELECT name INTO v_result
    FROM platform.get_unit_from_series(v_series_id);

    ASSERT v_result = 'test_unit',
        format('Unit name should be test_unit but got %s', v_result);

    -- Test 2: Non-existent series
    ASSERT NOT EXISTS (
        SELECT 1 FROM platform.get_unit_from_series(-1)
    ), 'Should return empty for non-existent series';

    RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests get_unit_from_vintage
-- ============================================================================
BEGIN;
DO $$
  DECLARE
v_unit_id int;
v_table_id bigint;
v_series_id bigint;
v_vintage_id int;
v_result character varying;
BEGIN
RAISE NOTICE 'Starting get_unit_from_vintage tests...';

-- Setup test data
-- First create a table (needed for series)
INSERT INTO platform.table (code, name, source_id, url)
VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
RETURNING id INTO v_table_id;

-- Create unit
INSERT INTO platform.unit (name)
VALUES ('test_unit')
RETURNING id INTO v_unit_id;

-- Create series
INSERT INTO platform.series (table_id, name_long, code, unit_id)
VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
RETURNING id INTO v_series_id;

-- Create vintage
INSERT INTO platform.vintage (series_id, published)
VALUES (v_series_id, CURRENT_TIMESTAMP)
RETURNING id INTO v_vintage_id;

-- Test 1: Basic retrieval
SELECT name INTO v_result
FROM platform.get_unit_from_vintage(v_vintage_id);

ASSERT v_result = 'test_unit',
format('Unit name should be test_unit but got %s', v_result);

-- Test 2: Non-existent vintage
ASSERT NOT EXISTS (
  SELECT 1 FROM platform.get_unit_from_vintage(-1)
), 'Should return empty for non-existent vintage';

RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
RAISE NOTICE 'Test failed: %', SQLERRM;
RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_vintage_from_series
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id1 int;
   v_vintage_id2 int;
   v_result int;
BEGIN
   RAISE NOTICE 'Starting get_vintage_from_series tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Create two vintages with different timestamps
   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-01 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id1;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-02 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id2;

   -- Test 1: Get most recent vintage
   SELECT id INTO v_result
   FROM platform.get_vintage_from_series(v_series_id);

   ASSERT v_result = v_vintage_id2,
       format('Should return most recent vintage ID %s but got %s',
              v_vintage_id2, v_result);

   -- Test 2: Get vintage valid at specific date
   SELECT id INTO v_result
   FROM platform.get_vintage_from_series(v_series_id, '2024-01-02 09:00:00'::timestamp);

   ASSERT v_result = v_vintage_id1,
       format('Should return vintage ID %s but got %s',
              v_vintage_id1, v_result);

   -- Test 3: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_vintage_from_series(-1)
   ), 'Should return empty for non-existent series';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Tests for get_vintage_from_series_code
-- ============================================================================
BEGIN;
DO $$
DECLARE
   v_unit_id int;
   v_table_id bigint;
   v_series_id bigint;
   v_vintage_id1 int;
   v_vintage_id2 int;
   v_result int;
BEGIN
   RAISE NOTICE 'Starting get_vintage_from_series_code tests...';

   -- Create prerequisites
   INSERT INTO platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TEST_SERIES', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Create two vintages with different timestamps
   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-01 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id1;

   INSERT INTO platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-02 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id2;

   -- Test 1: Get most recent vintage
   SELECT id INTO v_result
   FROM platform.get_vintage_from_series_code('TEST_SERIES');

   ASSERT v_result = v_vintage_id2,
       format('Should return most recent vintage ID %s but got %s',
              v_vintage_id2, v_result);

   -- Test 2: Get vintage valid at specific date
   SELECT id INTO v_result
   FROM platform.get_vintage_from_series_code('TEST_SERIES', '2024-01-02 09:00:00'::timestamp);

   ASSERT v_result = v_vintage_id1,
       format('Should return vintage ID %s but got %s',
              v_vintage_id1, v_result);

   -- Test 3: Non-existent series code
   ASSERT NOT EXISTS (
       SELECT 1 FROM platform.get_vintage_from_series_code('NONEXISTENT')
   ), 'Should return empty for non-existent series code';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Test for get_vintages_from_series function
-- ============================================================================
BEGIN;

DO $$
DECLARE
    v_table_id BIGINT;
    v_series_id BIGINT;
    v_vintage_id1 BIGINT;
    v_vintage_id2 BIGINT;
    v_vintage_id3 BIGINT;
    v_count INTEGER;
    v_first_id BIGINT;
    v_test_code VARCHAR := 'TEST_VINT_' || floor(random() * 10000)::TEXT;
BEGIN
    RAISE NOTICE 'Starting tests for get_vintages_from_series...';

    -- Create test data
    RAISE NOTICE 'Creating test table, series and vintages...';

    -- Create test table
    INSERT INTO platform.table (code, name, source_id)
    VALUES (v_test_code, 'Test Vintages From Series', 1)
    RETURNING id INTO v_table_id;

    -- Create test series
    INSERT INTO platform.series (table_id, name_long, code)
    VALUES (v_table_id, 'Test Series For Vintages', 'TSFV01')
    RETURNING id INTO v_series_id;

    -- Create three vintages with different timestamps
    INSERT INTO platform.vintage (series_id, published)
    VALUES (v_series_id, NOW() - INTERVAL '3 days')
    RETURNING id INTO v_vintage_id1;

    INSERT INTO platform.vintage (series_id, published)
    VALUES (v_series_id, NOW() - INTERVAL '2 days')
    RETURNING id INTO v_vintage_id2;

    INSERT INTO platform.vintage (series_id, published)
    VALUES (v_series_id, NOW() - INTERVAL '1 day')
    RETURNING id INTO v_vintage_id3;

    RAISE NOTICE 'Created test data with table_id: %, series_id: %, vintage_ids: %, %, %',
        v_table_id, v_series_id, v_vintage_id1, v_vintage_id2, v_vintage_id3;

    -- Test 1: Count the number of vintages returned
    SELECT COUNT(*) INTO v_count
    FROM platform.get_vintages_from_series(v_series_id);

    ASSERT v_count = 3,
        format('Expected 3 vintages, got %s', v_count);
    RAISE NOTICE 'Test 1 PASSED: Got % vintages as expected', v_count;

    -- Test 2: Verify ordering (newest first)
    SELECT id INTO v_first_id
    FROM platform.get_vintages_from_series(v_series_id)
    LIMIT 1;

    ASSERT v_first_id = v_vintage_id3,
        format('Expected newest vintage (ID %s) first, got %s', v_vintage_id3, v_first_id);
    RAISE NOTICE 'Test 2 PASSED: Newest vintage is first as expected (ID %)', v_first_id;

    -- Test 3: Test with non-existent series_id
    SELECT COUNT(*) INTO v_count
    FROM platform.get_vintages_from_series(999999);

    ASSERT v_count = 0,
        format('Expected 0 vintages for non-existent series, got %s', v_count);
    RAISE NOTICE 'Test 3 PASSED: Non-existent series test passed';

    RAISE NOTICE 'All tests for get_vintages_from_series passed!';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Test failed: %', SQLERRM;
    RAISE;
END $$;
ROLLBACK;

-- ============================================================================
-- Test for get_vintages_with_hashes_for_series function
-- ============================================================================
BEGIN;

DO $$
DECLARE
    v_table_id bigint;
    v_series_id bigint;
    v_v1_id INTEGER;
    v_v2_id INTEGER;
    v_v3_id INTEGER;
    result_count INTEGER;
    first_id INTEGER;
    first_full_hash TEXT;
    first_partial_hash TEXT;
    full_hash_count INTEGER;
    partial_hash_count INTEGER;
BEGIN
    RAISE NOTICE 'Starting tests for get_vintages_with_hashes_for_series...';

    -- Create test data
    RAISE NOTICE 'Creating test data (table, series, and vintages)...';

    -- Create test table
    INSERT INTO platform.table (code, name, source_id, keep_vintage)
    VALUES ('TEST_VINT_HASH', 'Test Vintages Hash Table', 1, TRUE)
    RETURNING id INTO v_table_id;

    -- Create test series
    INSERT INTO platform.series (table_id, name_long, code)
    VALUES (v_table_id, 'Test Series for Vintage Hashes', 'TVHS01')
    RETURNING id INTO v_series_id;

    -- Insert test vintages with specific hash patterns
    INSERT INTO platform.vintage (series_id, published, full_hash, partial_hash)
    VALUES (v_series_id, NOW() - INTERVAL '3 days', 'hash1_full', 'hash1_partial')
    RETURNING id INTO v_v1_id;

    INSERT INTO platform.vintage (series_id, published, full_hash, partial_hash)
    VALUES (v_series_id, NOW() - INTERVAL '2 days', 'hash2_full', 'hash1_full')
    RETURNING id INTO v_v2_id;

    INSERT INTO platform.vintage (series_id, published, full_hash, partial_hash)
    VALUES (v_series_id, NOW() - INTERVAL '1 day', 'hash3_full', 'hash2_full')
    RETURNING id INTO v_v3_id;

    -- Show some information about created test data
    RAISE NOTICE 'Test data created - table_id: %, series_id: %, vintage_ids: %, %, %',
        v_table_id, v_series_id, v_v1_id, v_v2_id, v_v3_id;

    -- Test 1: Verify we get all three vintages
    RAISE NOTICE 'Test 1: Verifying we get all three vintages...';

    SELECT count(*) INTO result_count
    FROM platform.get_vintages_with_hashes_for_series(v_series_id);

    IF result_count = 3 THEN
        RAISE NOTICE 'Test 1 PASSED: Got % vintages as expected', result_count;
    ELSE
        RAISE EXCEPTION 'Test 1 FAILED: Expected 3 vintages, got %', result_count;
    END IF;

    -- Test 2: Verify ordering (most recent first)
    RAISE NOTICE 'Test 2: Verifying ordering (most recent first)...';

    SELECT id, full_hash, partial_hash INTO first_id, first_full_hash, first_partial_hash
    FROM platform.get_vintages_with_hashes_for_series(v_series_id)
    LIMIT 1;

    IF first_id = v_v3_id THEN
        RAISE NOTICE 'Test 2a PASSED: Most recent vintage (ID %) is first as expected', first_id;
    ELSE
        RAISE EXCEPTION 'Test 2a FAILED: Expected ID %, got %', v_v3_id, first_id;
    END IF;

    IF first_full_hash = 'hash3_full' THEN
        RAISE NOTICE 'Test 2b PASSED: Full hash is correct (hash3_full)';
    ELSE
        RAISE EXCEPTION 'Test 2b FAILED: Expected full_hash to be hash3_full, got %', first_full_hash;
    END IF;

    IF first_partial_hash = 'hash2_full' THEN
        RAISE NOTICE 'Test 2c PASSED: Partial hash is correct (hash2_full)';
    ELSE
        RAISE EXCEPTION 'Test 2c FAILED: Expected partial_hash to be hash2_full, got %', first_partial_hash;
    END IF;

    -- Test 3: Verify all hashes are returned correctly
    RAISE NOTICE 'Test 3: Verifying all hashes are returned correctly...';

    SELECT
        COUNT(*) FILTER (WHERE full_hash IS NOT NULL),
        COUNT(*) FILTER (WHERE partial_hash IS NOT NULL)
    INTO
        full_hash_count,
        partial_hash_count
    FROM platform.get_vintages_with_hashes_for_series(v_series_id);

    IF full_hash_count = 3 THEN
        RAISE NOTICE 'Test 3a PASSED: All % vintages have full hashes', full_hash_count;
    ELSE
        RAISE EXCEPTION 'Test 3a FAILED: Expected 3 full hashes, got %', full_hash_count;
    END IF;

    IF partial_hash_count = 3 THEN
        RAISE NOTICE 'Test 3b PASSED: All % vintages have partial hashes', partial_hash_count;
    ELSE
        RAISE EXCEPTION 'Test 3b FAILED: Expected 3 partial hashes, got %', partial_hash_count;
    END IF;

    -- Cleanup
    RAISE NOTICE 'Cleaning up test data...';
    DELETE FROM platform.vintage WHERE id IN (v_v1_id, v_v2_id, v_v3_id);
    DELETE FROM platform.series WHERE id = v_series_id;
    DELETE FROM platform.table WHERE id = v_table_id;

    RAISE NOTICE 'All tests completed successfully!';
END $$;
ROLLBACK;
