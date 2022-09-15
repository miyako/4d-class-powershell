//%attributes = {}
$data:=cs.TEST.new().run().data

ALERT($data.join("\\r"))