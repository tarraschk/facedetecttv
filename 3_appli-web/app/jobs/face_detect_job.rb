# Class FaceDetectJob permettant de détecter les faces d'une image
class FaceDetectJob < ApplicationJob
  queue_as :opencv_detect

  def perform
    #TODO
  end
end
