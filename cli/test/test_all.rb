$LOAD_PATH << "./test"
$LOAD_PATH << "./lib"

Dir.glob("./test/test_*.rb").each { |file| require file }
