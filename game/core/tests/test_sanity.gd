extends GdUnitTestSuite
## Proves the test runner itself works (M00-T2): if this fails, no other result can be trusted.


func test_one_plus_one_is_two() -> void:
	assert_int(1 + 1).is_equal(2)
