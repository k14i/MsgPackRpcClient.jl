function get_dataset()
  [
    {"method" => "echo", "arg" => nothing},
    {"method" => "echo", "arg" => true},
    {"method" => "echo", "arg" => false},
    {"method" => "echo", "arg" => 1<<31},
    {"method" => "echo", "arg" => ""},
    {"method" => "echo", "arg" => "String"},
    {"method" => "echo", "arg" => []},
    {"method" => "echo", "arg" => {}},
    {"method" => "echo", "arg" => [10, 20, 30]},
    {"method" => "echo", "arg" => [10, "20", 30]},
    {"method" => "echo", "arg" => {10, 20, 30}},
    {"method" => "echo", "arg" => {{10, 20, 30}, {40, 50}, {60}} },
    {"method" => "echo", "arg" => {"key" => "value"}},
    {"method" => "echo", "arg" => {"k1" => "v1", "k2" => "v2"}},
    {"method" => "echo", "arg" => {"k1"=>nothing, "k2"=>false, "k3"=>"", "k4"=>{}, "k5"=>{"k5.1"=>false, "k5.2"=>{"k5.2.1"=>1<<31} } } },
  #  {"method" => "echo", "arg" => π },
    {"method" => "echo", "arg" => (), "expect" => {} },
    {"method" => "echo", "arg" => ((10,20,30,),(40,50,),(60,),), "expect" => {{10,20,30},{40,50},{60}} },
  ]
end

function get_dataset_for_arguments()
  [
    {"method" => "echo", "arg1" => 1, "arg2" => 2, "arg3" => 3, "arg4" => 4, "expect" => {1,2,3,4}}
  ]
end
