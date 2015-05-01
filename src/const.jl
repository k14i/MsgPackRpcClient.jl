const REQUEST  = 0  # [0, msgid, method, param]
const RESPONSE = 1  # [1, msgid, error, result]
const NOTIFY   = 2  # [2, method, param]
const NO_METHOD_ERROR = 0x01
const ARGUMENT_ERROR  = 0x02

const TIMEOUT_IN_SEC = 10.0
const DEFAULT_INTERVAL = 0.001
const DEFAULT_PORT_NUMBER = 5000
const DEFAULT_SYNC_POLICY = true
const BIT_OF_MSGID = 32
