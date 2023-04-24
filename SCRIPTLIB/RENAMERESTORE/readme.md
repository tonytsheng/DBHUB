Rename and Restore RDS 

Customer Use Case
- Restore an RDS instance from a snapshot to a new instance
- Applications have difficulty changing endpoints

Instead we can:
- Rename the old instance to something else
- Restore a snapshot from this instance to the old instance name
- Applications do not have to make any changes assuming endpoint stays the same
- RDS does not guarantee endpoints will stay the same
