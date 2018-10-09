class IndexPresenter
  def sleep_button_text
    Sleep.awake? ? "Go to sleep" : "Wake up"
  end

  def staggered_thresholds_button_text
    "Submit"
  end
end
