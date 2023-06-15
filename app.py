# import PIL as Image
# # import torch
# import numpy as np
# import tensorflow as tf
# import tensorflow_hub as hub
# import requests
# import urllib

import tensorflow as tf
import numpy as np
from PIL import Image
import requests
from io import BytesIO


# model loading
# classification_model = tf.keras.models.load_model(
#     'model/model.h5',
#     custom_objects={'KerasLayer':hub.KerasLayer}
# )

model_path = "model/model.tflite"
interpreter = tf.lite.Interpreter(model_path=model_path)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

input_shape = input_details[0]["shape"]
output_shape = output_details[0]["shape"]

# object_detection_model= torch.hub.load('ultralytics/yolov5', 'custom', 'model/model_v3_1_0.pt')

# list of class
label_classes = ['freshapples','freshbanana','freshoranges','rottenapples','rottenbanana','rottenoranges']
# label_object_detection = ['apple', 'orange', 'banana']

# get image from url
# def url_to_image(url):
# 	resp = urllib.request.urlopen(url)
# 	image = np.asarray(bytearray(resp.read()), dtype="uint8")
# 	image = cv2.imdecode(image, cv2.IMREAD_COLOR)
# 	return image

# def predict(url):
#   image = url_to_image(url)
#   result = object_detection_model(image)
#   fruit_name  = []
#   freshness = []
#   for detect in result.xyxy[0]:
#     xB = int(detect[2])
#     xA = int(detect[0])
#     yB = int(detect[3])
#     yA = int(detect[1])
#     label_index = int(detect[5])
#     label = label_object_detection[label_index]   
#     fruit_name.append(label)
     
#     load = image[yA:yB, xA:xB]
#     load = load/255.0
#     load = cv2.resize(load, (224,224))
#     z = tf.keras.utils.img_to_array(load)
#     z = np.expand_dims(z, axis=0)
#     images = np.vstack([z])
#     classes = classification_model.predict(images)
#     index = np.argmax(classes) 
#     freshness_level = label_classes[index]
#     freshness.append(freshness_level)
#   return ({"name": fruit_name, "freshness": freshness})   
    
# if __name__ == "__main__":
#   import sys
  
#   if len(sys.argv) < 2:
#     print("get output <url>")
#     sys.exit(1)
  
#   url = sys.argv[1]
#   output = predict(url)
  
#   print(output)


def preprocess_image(image_url):
    response = requests.get(image_url)
    if response.status_code == 200:
        image = Image.open(BytesIO(response.content)).convert("RGB")
        image = image.resize((input_shape[1], input_shape[2]))
        image = np.array(image)
        image = image / 255.0
        image = np.expand_dims(image, axis=0)
        image = image.astype(np.float32)
        return image
    else:
        raise ValueError("Failed to fetch image from the provided URL.")

def postprocess_output(output):
    predicted_index = np.argmax(output)
    predicted_class = label_classes[predicted_index]
    return predicted_class
  
def predict(image_url):
    image = preprocess_image(image_url)

    interpreter.set_tensor(input_details[0]['index'], image)
    interpreter.invoke()
    output = interpreter.get_tensor(output_details[0]['index'])
    output = postprocess_output(output)

    return output
  
if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python model_loader.py <image_url>")
        sys.exit(1)

    image_url = sys.argv[1]
    prediction = predict(image_url)

    print(prediction)
