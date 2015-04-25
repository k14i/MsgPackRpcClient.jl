function get_dataset()
  [
    {"method" => "echo", "message" => nothing},
    {"method" => "echo", "message" => true},
    {"method" => "echo", "message" => false},
    {"method" => "echo", "message" => 1<<31},
    {"method" => "echo", "message" => ""},
    {"method" => "echo", "message" => "String"},
    {"method" => "echo", "message" => []},
    {"method" => "echo", "message" => {}},
    {"method" => "echo", "message" => [10, 20, 30]},
    {"method" => "echo", "message" => [10, "20", 30]},
    {"method" => "echo", "message" => {10, 20, 30}},
    {"method" => "echo", "message" => {{10, 20, 30}, {40, 50}, {60}} },
    {"method" => "echo", "message" => {"key" => "value"}},
    {"method" => "echo", "message" => {"k1" => "v1", "k2" => "v2"}},
    {"method" => "echo", "message" => {"k1"=>nothing, "k2"=>false, "k3"=>"", "k4"=>{}, "k5"=>{"k5.1"=>false, "k5.2"=>{"k5.2.1"=>1<<31} } } },
  #  {"method" => "echo", "message" => π },
    {"method" => "echo", "message" => (), "expect" => {} },
    {"method" => "echo", "message" => ((10,20,30,),(40,50,),(60,),), "expect" => {{10,20,30},{40,50},{60}} },
  ]
end

