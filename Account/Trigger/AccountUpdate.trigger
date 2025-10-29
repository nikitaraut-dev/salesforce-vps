trigger AccountUpdate on Account (before update) { 
	if (Trigger.isBefore) {
		if (Trigger.isUpdate) {
			if(Constants.firstRun) {
				AccountUpdateHelper.handleUpdate(Trigger.new, Trigger.oldMap);
				Constants.firstRun = false;
			} else {
				Constants.firstRun = true;
			}
		}
	}

}