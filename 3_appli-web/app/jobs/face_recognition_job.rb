# Class FaceRecognitionJob permettant de détecter les faces d'une image
class FaceRecognitionJob < ApplicationJob
  queue_as :opencv_recognition

  def perform
    #TODO
  end
end
