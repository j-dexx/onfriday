module DateHelper

  def simple_datetime_format(datetime)
    datetime.strftime("%H:%M %d/%m/%Y")
  end

  def simple_date_format(date)
    date.strftime("%d/%m/%Y")
  end
  
  def simple_time_format(time)
    time.strftime("%H:%M")
  end
    
end
