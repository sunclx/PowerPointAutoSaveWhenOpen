#include <String.au3>
$a = "dkdk,djkdfj,dkfdjk,djfkd"
$b = _StringExplode($a,',')
ConsoleWrite($b[2])