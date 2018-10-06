class IndexPresenter
  def sleep_button_text
    Sleep.awake? ? "Go to sleep" : "Wake up"
  end
end
