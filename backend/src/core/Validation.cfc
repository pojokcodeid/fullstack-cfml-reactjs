component {

	public struct function validate(required struct data, required struct rules) {
		var errors = [];
		try{
			for (var field in rules) {
				var ruleSet = listToArray(rules[field], "|");
				var value = data[field];
	
				for (var rule in ruleSet) {
					var valid = true;
					var ruleName = rule;
					var ruleParam = "";
	
					// Handle rules with parameters (like min:3)
					if (find(":", rule)) {
					var parts = listToArray(rule, ":");
					ruleName = parts[1];
					ruleParam = parts[2];
					}
	
					switch (ruleName) {
					case "required":
						valid = structKeyExists(data, field) && len(trim(value)) > 0;
						if (!valid) arrayAppend(errors, "#field# is required.");
						break;
	
					case "is_email":
						valid = isValid("email", value);
						if (!valid) arrayAppend(errors, "#field# must be a valid email.");
						break;
	
					case "is_numeric":
						valid = isNumeric(value);
						if (!valid) arrayAppend(errors, "#field# must be numeric.");
						break;
	
					case "min":
						valid = len(trim(value)) >= val(ruleParam);
						if (!valid) arrayAppend(errors, "#field# must be at least #ruleParam# characters.");
						break;
				
					case "max":
						valid = len(trim(value)) <= val(ruleParam);
						if (!valid) arrayAppend(errors, "#field# must be at most #ruleParam# characters.");
						break;
	
					case "is_date":
						valid = isDate(value);
						if (!valid) arrayAppend(errors, "#field# must be a valid date.");
						break;
	
					case "is_time":
						valid = isTime(value);
						if (!valid) arrayAppend(errors, "#field# must be a valid time.");
						break;
	
					case "is_datetime":
						valid = isDateTime(value);
						if (!valid) arrayAppend(errors, "#field# must be a valid datetime.");
						break;
	
					case "is_url":
						valid = isUrl(value);
						if (!valid) arrayAppend(errors, "#field# must be a valid url.");
						break;
	
					case "is_ip":
						valid = isIp(value);
						if (!valid) arrayAppend(errors, "#field# must be a valid ip address.");
						break;
	
					case "strong_password":
						valid = len(value) >= 8 
								 && reFind("[A-Z]", value) 
								 && reFind("[a-z]", value)
								 && reFind("[0-9]", value)
								 && reFind("[^A-Za-z0-9]", value); // simbol
						if (!valid) {
						  arrayAppend(errors, "#field# must be a strong password (min 8 chars, uppercase, lowercase, number, symbol).");
						}
						break;
						
					// 🔄 Extend here for more rules:
					default:
						// Unknown rule, ignore
					}
	
					if (!valid) break;
				}
			}
		}catch (any e) {
			arrayAppend(errors, "#e.message#");
		}

		return {
			success = arrayLen(errors) == 0,
			errors = errors
		};
	}
}