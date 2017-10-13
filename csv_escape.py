def escape(payload):
     if payload[0] in ('@','+','-', '=', '|', '%'):
             payload = payload.replace("|", "\|")
             payload = "'" + payload + "'"
     return payload

# An example of payload string
payload = "@cmd|' /C calc'!A0"
print "The Unescaped version is: " +  payload
print "When passed through escape function the value is: " + escape(payload)
