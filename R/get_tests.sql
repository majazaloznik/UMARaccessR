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
    INSERT INTO test_platform.table (code, name, source_id, url)
    VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create unit
    INSERT INTO test_platform.unit (name)
    VALUES ('test_unit')
    RETURNING id INTO v_unit_id;

    -- Create series
    INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
    VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
    RETURNING id INTO v_series_id;

    -- Test 1: Basic retrieval
    SELECT name INTO v_result
    FROM test_platform.get_unit_from_series(v_series_id);

    ASSERT v_result = 'test_unit',
        format('Unit name should be test_unit but got %s', v_result);

    -- Test 2: Non-existent series
    ASSERT NOT EXISTS (
        SELECT 1 FROM test_platform.get_unit_from_series(-1)
    ), 'Should return empty for non-existent series';

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
    INSERT INTO test_platform.table (code, name, source_id, url)
    VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    INSERT INTO test_platform.unit (name)
    VALUES ('test_unit')
    RETURNING id INTO v_unit_id;

    INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
    VALUES (v_table_id, 'Test Series Long Name', 'TS1', v_unit_id)
    RETURNING id INTO v_series_id;

    INSERT INTO test_platform.vintage (series_id, published)
    VALUES (v_series_id, CURRENT_TIMESTAMP)
    RETURNING id INTO v_vintage_id;

    -- Test 1: Basic retrieval
    SELECT name_long INTO v_result
    FROM test_platform.get_series_name_from_vintage(v_vintage_id);

    ASSERT v_result = 'Test Series Long Name',
        format('Series name should be "Test Series Long Name" but got %s', v_result);

    -- Test 2: Non-existent vintage
    ASSERT NOT EXISTS (
        SELECT 1 FROM test_platform.get_series_name_from_vintage(-1)
    ), 'Should return empty for non-existent vintage';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series Long Name', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT name_long INTO v_result
   FROM test_platform.get_series_name_from_series(v_series_id);

   ASSERT v_result = 'Test Series Long Name',
       format('Series name should be "Test Series Long Name" but got %s', v_result);

   -- Test 2: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_series_name_from_series(-1)
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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series Long Name', 'TEST_SERIES', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT name_long INTO v_result
   FROM test_platform.get_series_name_from_series_code('TEST_SERIES');

   ASSERT v_result = 'Test Series Long Name',
       format('Series name should be "Test Series Long Name" but got %s', v_result);

   -- Test 2: Non-existent code
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_series_name_from_series_code('NONEXISTENT')
   ), 'Should return empty for non-existent series code';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;



-- ============================================================================
-- Tests
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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table Name', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;

   -- Test 1: Basic retrieval
   SELECT name INTO v_result
   FROM test_platform.get_table_name_from_vintage(v_vintage_id);

   ASSERT v_result = 'Test Table Name',
       format('Table name should be "Test Table Name" but got %s', v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_table_name_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;


-- ============================================================================
-- Tests
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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table Name', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT name INTO v_result
   FROM test_platform.get_table_name_from_series(v_series_id);

   ASSERT v_result = 'Test Table Name',
       format('Table name should be "Test Table Name" but got %s', v_result);

   -- Test 2: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_table_name_from_series(-1)
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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   -- Create series with known interval
   INSERT INTO test_platform.series (table_id, name_long, code, unit_id, interval_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id, 'M')
   RETURNING id INTO v_series_id;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;

   -- Test 1: Basic retrieval
   SELECT interval_id INTO v_result
   FROM test_platform.get_interval_from_vintage(v_vintage_id);

   ASSERT v_result = 'M',
       format('Interval ID should be "M" but got %s', v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_interval_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   -- Create series with known interval
   INSERT INTO test_platform.series (table_id, name_long, code, unit_id, interval_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id, 'M')
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT interval_id INTO v_result
   FROM test_platform.get_interval_from_series(v_series_id);

   ASSERT v_result = 'M',
       format('Interval ID should be "M" but got %s', v_result);

   -- Test 2: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_interval_from_series(-1)
   ), 'Should return empty for non-existent series';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Create two vintages with different timestamps
   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-01 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id1;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-02 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id2;

   -- Test 1: Get most recent vintage
   SELECT id INTO v_result
   FROM test_platform.get_vintage_from_series(v_series_id);

   ASSERT v_result = v_vintage_id2,
       format('Should return most recent vintage ID %s but got %s',
              v_vintage_id2, v_result);

   -- Test 2: Get vintage valid at specific date
   SELECT id INTO v_result
   FROM test_platform.get_vintage_from_series(v_series_id, '2024-01-02 09:00:00'::timestamp);

   ASSERT v_result = v_vintage_id1,
       format('Should return vintage ID %s but got %s',
              v_vintage_id1, v_result);

   -- Test 3: Non-existent series
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_vintage_from_series(-1)
   ), 'Should return empty for non-existent series';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;



-- ============================================================================
-- Tests
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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TEST_SERIES', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Create two vintages with different timestamps
   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-01 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id1;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, '2024-01-02 10:00:00'::timestamp)
   RETURNING id INTO v_vintage_id2;

   -- Test 1: Get most recent vintage
   SELECT id INTO v_result
   FROM test_platform.get_vintage_from_series_code('TEST_SERIES');

   ASSERT v_result = v_vintage_id2,
       format('Should return most recent vintage ID %s but got %s',
              v_vintage_id2, v_result);

   -- Test 2: Get vintage valid at specific date
   SELECT id INTO v_result
   FROM test_platform.get_vintage_from_series_code('TEST_SERIES', '2024-01-02 09:00:00'::timestamp);

   ASSERT v_result = v_vintage_id1,
       format('Should return vintage ID %s but got %s',
              v_vintage_id1, v_result);

   -- Test 3: Non-existent series code
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_vintage_from_series_code('NONEXISTENT')
   ), 'Should return empty for non-existent series code';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;



   INSERT INTO test_platform.data_points (vintage_id, period_id, value)
   VALUES
       (v_vintage_id, '2024Q1', 100.5),
       (v_vintage_id, '2024Q2', 101.2),
       (v_vintage_id, '2024Q3', 102.7);

   -- Test 1: Check data retrieval and ordering
   FOR v_result IN
       SELECT * FROM test_platform.get_data_points_from_vintage(v_vintage_id)
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
           FROM test_platform.get_data_points_from_vintage(v_vintage_id)
       ) t
       WHERE prev_period IS NULL OR prev_period < period_id
   ), 'Results should be ordered by period_id';

   -- Test 3: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_data_points_from_vintage(-1)
   ), 'Should return empty for non-existent vintage';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;


-- ============================================================================
-- Tests
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
    INSERT INTO test_platform.table (code, name, source_id, url)
    VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    INSERT INTO test_platform.unit (name)
    VALUES ('test_unit')
    RETURNING id INTO v_unit_id;

    INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
    VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
    RETURNING id INTO v_series_id;


    INSERT INTO test_platform.vintage (series_id, published)
    VALUES (v_series_id, '2024-01-01 10:00:00'::timestamp)
    RETURNING id INTO v_vintage_id1;

    INSERT INTO test_platform.data_points (vintage_id, period_id, value)
    VALUES
        (v_vintage_id1, '2024Q1', 100.5),
        (v_vintage_id1, '2024Q2', 101.2);

    INSERT INTO test_platform.vintage (series_id, published)
    VALUES (v_series_id, '2024-01-02 10:00:00'::timestamp)
    RETURNING id INTO v_vintage_id2;

    INSERT INTO test_platform.data_points (vintage_id, period_id, value)
    VALUES
        (v_vintage_id2, '2024Q1', 100.7),
        (v_vintage_id2, '2024Q2', 101.4),
        (v_vintage_id2, '2024Q3', 102.0);

    -- Test 1: Get most recent vintage's data
    FOR v_result IN
        SELECT * FROM test_platform.get_data_points_from_series(v_series_id)
    LOOP
        ASSERT v_result.value IS NOT NULL,
            'Value should not be null in most recent vintage';
    END LOOP;

    -- Test 2: Get data valid at specific date
    FOR v_result IN
        SELECT * FROM test_platform.get_data_points_from_series(
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
            FROM test_platform.get_data_points_from_series(v_series_id)
        ) t
        WHERE prev_period IS NULL OR prev_period < period_id
    ), 'Results should be ordered by period_id';

    -- Test 4: Non-existent series
    ASSERT NOT EXISTS (
        SELECT 1 FROM test_platform.get_data_points_from_series(-1)
    ), 'Should return empty for non-existent series';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   -- Set specific timestamp for testing
   v_test_timestamp := '2024-01-01 10:00:00 CET'::timestamp with time zone;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, v_test_timestamp)
   RETURNING id INTO v_vintage_id;

   -- Test 1: Basic retrieval with timezone
   SELECT published INTO v_result
   FROM test_platform.get_date_published_from_vintage(v_vintage_id);

   ASSERT v_result = v_test_timestamp,
       format('Published timestamp should be %s but got %s',
              v_test_timestamp, v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_date_published_from_vintage(-1)
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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST1', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   INSERT INTO test_platform.unit (name)
   VALUES ('test_unit')
   RETURNING id INTO v_unit_id;

   INSERT INTO test_platform.series (table_id, name_long, code, unit_id)
   VALUES (v_table_id, 'Test Series', 'TS1', v_unit_id)
   RETURNING id INTO v_series_id;

   INSERT INTO test_platform.vintage (series_id, published)
   VALUES (v_series_id, CURRENT_TIMESTAMP)
   RETURNING id INTO v_vintage_id;


   INSERT INTO test_platform.data_points (vintage_id, period_id, value)
   VALUES
       (v_vintage_id, '2024Q1', 100.5),
       (v_vintage_id, '2024Q2', 101.2),
       (v_vintage_id, '2024Q3', NULL),
       (v_vintage_id, '2024Q4', NULL);

   -- Test 1: Get last non-null period
   SELECT period_id INTO v_result
   FROM test_platform.get_last_period_from_vintage(v_vintage_id);

   ASSERT v_result = '2024Q2',
       format('Last period should be 2024Q2 but got %s', v_result);

   -- Test 2: Non-existent vintage
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_last_period_from_vintage(-1)
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
   INSERT INTO test_platform.source (id, name, name_long, url)
   VALUES (100, 'TEST_SOURCE', 'Test Source Long Name', 'http://test.com')
   RETURNING id INTO v_source_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM test_platform.get_source_code_from_source_name('TEST_SOURCE');

   ASSERT v_result = v_source_id,
       format('Source ID should be %s but got %s', v_source_id, v_result);

   -- Test 2: Non-existent source
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_source_code_from_source_name('NONEXISTENT')
   ), 'Should return empty for non-existent source';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM test_platform.get_table_id_from_table_code('TEST_TABLE');

   ASSERT v_result = v_table_id,
       format('Table ID should be %s but got %s', v_table_id, v_result);

   -- Test 2: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_table_id_from_table_code('NONEXISTENT')
   ), 'Should return empty for non-existent table';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test dimension
   INSERT INTO test_platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM test_platform.get_tab_dim_id_from_table_id_and_dimension(v_table_id, 'test_dimension');

   ASSERT v_result = v_dimension_id,
       format('Dimension ID should be %s but got %s', v_dimension_id, v_result);

   -- Test 2: Non-existent dimension
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_tab_dim_id_from_table_id_and_dimension(v_table_id, 'nonexistent')
   ), 'Should return empty for non-existent dimension';

   -- Test 3: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_tab_dim_id_from_table_id_and_dimension(-1, 'test_dimension')
   ), 'Should return empty for non-existent table';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create multiple test series
   INSERT INTO test_platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series 1', 'TS1')
   RETURNING id INTO v_series_id1;

   INSERT INTO test_platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series 2', 'TS2')
   RETURNING id INTO v_series_id2;

   -- Test 1: Count results
   SELECT COUNT(*) INTO v_count
   FROM test_platform.get_series_ids_from_table_id(v_table_id);

   ASSERT v_count = 2,
       format('Should return 2 series but got %s', v_count);

   -- Test 2: Non-existent table
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_series_ids_from_table_id(-1)
   ), 'Should return empty for non-existent table';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test dimension
   INSERT INTO test_platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Insert test dimension levels
   INSERT INTO test_platform.dimension_levels (tab_dim_id, level_value, level_text)
   VALUES
       (v_dimension_id, 'A', 'Level A'),
       (v_dimension_id, 'B', 'Level B'),
       (v_dimension_id, 'C', 'Level C');

   -- Test 1: Count results
   SELECT COUNT(*) INTO v_count
   FROM test_platform.get_dimension_levels_from_table_id(v_table_id);

   ASSERT v_count = 3,
       format('Should return 3 levels but got %s', v_count);

   -- Test 2: Check ordering
   FOR v_result IN
       SELECT * FROM test_platform.get_dimension_levels_from_table_id(v_table_id)
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
       SELECT 1 FROM test_platform.get_dimension_levels_from_table_id(-1)
   ), 'Should return empty for non-existent table';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test series
   INSERT INTO test_platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series', 'TEST_SERIES')
   RETURNING id INTO v_series_id;

   -- Test 1: Basic retrieval
   SELECT id INTO v_result
   FROM test_platform.get_series_id_from_series_code('TEST_SERIES');

   ASSERT v_result = v_series_id,
       format('Series ID should be %s but got %s', v_series_id, v_result);

   -- Test 2: Non-existent series code
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_series_id_from_series_code('NONEXISTENT')
   ), 'Should return empty for non-existent series code';

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
   INSERT INTO test_platform.source (id, name, name_long, url)
   VALUES (100, 'TEST_SOURCE', 'Test Source', 'http://test.com')
   RETURNING id INTO v_source_id;

   -- Create multiple categories
   INSERT INTO test_platform.category (id, name, source_id)
   VALUES
       (1, 'Category 1', v_source_id),
       (2, 'Category 2', v_source_id),
       (5, 'Category 5', v_source_id);

   -- Test 1: Get max ID
   SELECT max_id INTO v_result
   FROM test_platform.get_max_category_id_for_source(v_source_id);

   ASSERT v_result = 5,
       format('Maximum category ID should be 5 but got %s', v_result);

   -- Test 2: Non-existent source
   SELECT max_id INTO v_result
   FROM test_platform.get_max_category_id_for_source(-1);

   ASSERT v_result = 0,
       'Should return 0 for source with no categories';

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
   INSERT INTO test_platform.umar_authors (name, initials, email)
   VALUES ('Test Author', 'TA', 'test@example.com');

   -- Test 1: Basic retrieval
   SELECT initials INTO v_result
   FROM test_platform.get_initials_from_author_name('Test Author');

   ASSERT v_result = 'TA',
       format('Author initials should be TA but got %s', v_result);

   -- Test 2: Non-existent author
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_initials_from_author_name('Nonexistent Author')
   ), 'Should return empty for non-existent author';

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
   INSERT INTO test_platform.umar_authors (name, initials, email)
   VALUES ('Test Author', 'TA', 'test@example.com');

   -- Test 1: Basic retrieval
   SELECT email INTO v_result
   FROM test_platform.get_email_from_author_initials('TA');

   ASSERT v_result = 'test@example.com',
       format('Author email should be test@example.com but got %s', v_result);

   -- Test 2: Non-existent initials
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_email_from_author_initials('XX')
   ), 'Should return empty for non-existent initials';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create dimension
   INSERT INTO test_platform.table_dimensions (table_id, dimension, is_time)
   VALUES (v_table_id, 'test_dimension', false)
   RETURNING id INTO v_dimension_id;

   -- Create dimension level
   INSERT INTO test_platform.dimension_levels (tab_dim_id, level_value, level_text)
   VALUES (v_dimension_id, 'VALUE_A', 'Text for A');

   -- Test 1: Basic retrieval
   SELECT level_value INTO v_result
   FROM test_platform.get_level_value_from_text(v_dimension_id, 'Text for A');

   ASSERT v_result = 'VALUE_A',
       format('Level value should be VALUE_A but got %s', v_result);

   -- Test 2: Non-existent level text
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_level_value_from_text(v_dimension_id, 'Nonexistent')
   ), 'Should return empty for non-existent level text';

   -- Test 3: Non-existent dimension ID
   ASSERT NOT EXISTS (
       SELECT 1 FROM test_platform.get_level_value_from_text(-1, 'Text for A')
   ), 'Should return empty for non-existent dimension ID';

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
    INSERT INTO test_platform.table (code, name, source_id, url)
    VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
    RETURNING id INTO v_table_id;

    -- Create dimensions (time and non-time)
    INSERT INTO test_platform.table_dimensions (table_id, dimension, is_time)
    VALUES
        (v_table_id, 'time_dim', true),
        (v_table_id, 'other_dim', false);

    -- Test 1: Basic retrieval
    SELECT dimension INTO v_result
    FROM test_platform.get_time_dimension_from_table_code('TEST_TABLE');

    ASSERT v_result = 'time_dim',
        format('Time dimension should be time_dim but got %s', v_result);

    -- Test 2: Non-existent table
    ASSERT NOT EXISTS (
        SELECT 1 FROM test_platform.get_time_dimension_from_table_code('NONEXISTENT')
    ), 'Should return empty for non-existent table';

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
   INSERT INTO test_platform.table (code, name, source_id, url)
   VALUES ('TEST_TABLE', 'Test Table', 1, 'http://test.com')
   RETURNING id INTO v_table_id;

   -- Create test series
   INSERT INTO test_platform.series (table_id, name_long, code)
   VALUES (v_table_id, 'Test Series', 'TS1')
   RETURNING id INTO v_series_id;

   -- Create multiple vintages with different dates
   INSERT INTO test_platform.vintage (series_id, published)
   VALUES
       (v_series_id, '2024-01-01 10:00:00'::timestamp),
       (v_series_id, '2024-01-02 10:00:00'::timestamp),
       (v_series_id, '2024-01-03 10:00:00'::timestamp);

   -- Test 1: Check we get correct number of distinct dates
   SELECT COUNT(*) INTO v_result_count
   FROM (
       SELECT DISTINCT published
       FROM test_platform.get_last_publication_date_from_table_id(v_table_id)
   ) t;

   ASSERT v_result_count = 3,
       format('Should find 3 distinct dates but found %s', v_result_count);

   -- Test 2: Check ordering
   ASSERT EXISTS (
       SELECT 1
       FROM (
           SELECT published,
                  LAG(published) OVER (ORDER BY published DESC) as prev_date
           FROM test_platform.get_last_publication_date_from_table_id(v_table_id)
       ) t
       WHERE prev_date IS NULL OR published < prev_date
   ), 'Results should be ordered by published date DESC';

   -- Test 3: Non-existent table
   SELECT COUNT(*) INTO v_result_count
   FROM test_platform.get_last_publication_date_from_table_id(-1);

   ASSERT v_result_count = 0,
       'Should return empty for non-existent table';

   RAISE NOTICE 'All tests passed successfully';

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'Test failed: %', SQLERRM;
   RAISE;
END $$;
ROLLBACK;
