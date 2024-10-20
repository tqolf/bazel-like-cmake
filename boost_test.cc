#define BOOST_TEST_MODULE ComplexBoostTest
#include <boost/any.hpp>
#include <boost/optional.hpp>
#include <boost/test/included/unit_test.hpp>
#include <boost/variant.hpp>
#include <stdexcept>
#include <string>

int process(const boost::optional<int> &opt) { return opt.value_or(0); }

std::string process(const boost::any &any_val) {
  if (any_val.type() == typeid(int)) {
    return "int: " + std::to_string(boost::any_cast<int>(any_val));
  } else if (any_val.type() == typeid(std::string)) {
    return "string: " + boost::any_cast<std::string>(any_val);
  }
  throw std::invalid_argument("Unsupported type");
}

struct visitor : public boost::static_visitor<int> {
  int operator()(int i) const { return i; }
  int operator()(const std::string &str) const { return str.length(); }
};

int process(const boost::variant<int, std::string> &var) {
  return boost::apply_visitor(visitor(), var);
}

BOOST_AUTO_TEST_CASE(test_optional) {
  boost::optional<int> a = 10;
  BOOST_CHECK_EQUAL(process(a), 10);

  a = boost::none;
  BOOST_CHECK_EQUAL(process(a), 0);
}
BOOST_AUTO_TEST_CASE(test_any) {
  boost::any val = 10;
  BOOST_CHECK_EQUAL(process(val), "int: 10");

  val = std::string("hello");
  BOOST_CHECK_EQUAL(process(val), "string: hello");

  BOOST_CHECK_THROW(process(boost::any(5.5)), std::invalid_argument);
}

BOOST_AUTO_TEST_CASE(test_variant) {
  boost::variant<int, std::string> var = 42;
  BOOST_CHECK_EQUAL(process(var), 42);

  var = "Boost";
  BOOST_CHECK_EQUAL(process(var), 5);
}
