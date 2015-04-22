module MsgPackRpcClientFuture

type Future
  timeout          :: Int
  callback_handler :: Any
  error_handler    :: Any
  result_handler   :: Any
  is_set           :: Bool
  error            :: Any
  result           :: Any
  raw              :: Any
  msg_id           :: Int
  task             :: Union(Task, Nothing)
end

end # module MsgPackRpcClientFuture


# module future
# 
# export Future
# 
# type Loop end
# type Error end
# type Result end
# type Callback end
# type Handler end
# 
# type Future
#   loop::Loop
#   error::Error
#   result::Result
#   set_flag::Bool
#   timeout::Int
#   callback::Callback
#   error_handler::Handler
#   result_handler::Handler
# 
#   join::Function
#   get::Function
#   set::Function
#   set_result::Function
#   set_error::Function
#   attach_callback::Function
#   attach_error_handler::Function
#   attach_result_handler::Function
#   step_timeout::Function
# 
#   function Future(loop, timeout, callback)
#     this                = new()
#     this.loop           = loop
#     this.error          = nothing
#     this.result         = nothing
#     this.set_flag       = false
#     this.timeout        = timeout
#     this.callback       = callback
#     this.error_handler  = nothing
#     this.result_handler = nothing
# 
#     this.join                  = function() join(this) end
#     this.get                   = function() get(this) end
#     this.set                   = function() set(this, error, result) end
#     this.set_result            = function() set_result(this, result) end
#     this.set_error             = function() set_error(this, error) end
#     this.attach_callback       = function() attach_callback(this, callback) end
#     this.attach_error_handler  = function() attach_error_handler(this, error_handler) end
#     this.attach_result_handler = function() attach_result_handler(this, result_handler) end
#     this.step_timeout          = function() step_timeout(this) end
# 
#     this
#   end
# 
#   function join(self::Future)
#     while (!self.set_flag)
#       self.loop.start()
#     end
#   end
# 
#   function get(self::Future)
#     self.join(self)
# 
#     assert(self.set_flag)
#     if (!self.set_flag)
#       error("RPCError(128)")
#     end
# 
#     if (self.result != nothing)
#       if (self.result_handler == nothing)
#         return self.result
#       else
#         self.result_handler(self.result)
#       end
#     else
#       if (self.error != nothing)
#         if (self.error_handler != nothing)
#           self.error_handler(self)
#         end
#       else
#         return self.result
#       end
#     end
#   end
# 
#   function set(self::Future, error::Error, result::Result)
#     self.error  = error
#     self.result = result
# 
#     if (self.callback)
#       self.callback(self)
#     end
#   end
# 
#   function set_result(self::Future, result::Result)
#     self.set(self, nothing, result)
#     self.set_flag = true
#   end
# 
#   function set_error(self::Future, error::Error)
#     self.set(self, error, nothing)
#     self.set_flag = true
#   end
# 
#   function attach_callback(self::Future, callback::Callback)
#     self.callback = callback
#   end
# 
#   function attach_error_handler(self::Future, handler::Hnadler)
#     self.error_handler = handler
#   end
# 
#   function attach_result_handler(self::Future, handler::Handler)
#     self.result_handler = handler
#   end
# 
#   function step_timeout(self::Future)
#     if self.timeout < 1
#       return true
#     else
#       self.timeout -= 1
#       return false
#     end
#   end
# 
# end
# 
# end # module future
