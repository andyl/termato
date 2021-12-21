defmodule Util.Time do
  def now do 
    Tzdata.TimeZoneDatabase
    |> Calendar.put_time_zone_database()

    DateTime.utc_now() 
    |> DateTime.shift_zone!("America/Los_Angeles") 
    |> Calendar.strftime("%y-%m-%d %H:%M:%S")
  end
end
