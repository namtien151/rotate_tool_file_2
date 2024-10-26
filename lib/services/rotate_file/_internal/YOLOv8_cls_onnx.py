# Ultralytics YOLO 🚀, AGPL-3.0 license

import cv2
import numpy as np
import onnxruntime as ort


# import time
# from loguru import logger


class YOLOv8:
    """YOLOv8 object detection model class for handling inference and visualization."""

    def __init__(self, onnx_model, input_image, confidence_thres=0.6):
        """
        Initializes an instance of the YOLOv8 class.

        Args:
            onnx_model: Path to the ONNX model.
            input_image: Path to the input image.
            confidence_thres: Confidence threshold for filtering detections.
        """
        self.img_height = None
        self.img_width = None
        self.scaling_factor = None
        self.input_image = input_image
        self.confidence_thres = confidence_thres

        self.onnx_model = onnx_model
        self.session = ort.InferenceSession(self.onnx_model,
                                            providers=["CUDAExecutionProvider", "CPUExecutionProvider"])
        model_inputs = self.session.get_inputs()
        input_shape = model_inputs[0].shape
        self.input_width = input_shape[2]
        self.input_height = input_shape[3]

    def preprocess(self):
        """
        Preprocesses the input image before performing inference.

        Returns:
            image_data: Preprocessed image data ready for inference.
        """

        # Decode the image
        self.input_image = np.array(self.input_image)
        # self.input_image = cv2.cvtColor(self.input_image, cv2.COLOR_BGR2RGB)
        self.img_height, self.img_width = self.input_image.shape[:2]

        # cv2.imshow('input_image', self.input_image)
        # cv2.waitKey(0)

        # Calculate the scaling factor for resizing
        scaling_factor = min(self.input_height / self.img_height, self.input_width / self.img_width)

        # Resize the image with padding (if needed)
        resized_image = cv2.resize(self.input_image, (0, 0), fx=scaling_factor, fy=scaling_factor)
        # print(resized_image)
        # cv2.imshow('resized_image', resized_image)
        # cv2.waitKey(0)

        # resized_image = resized_image.astype(np.float32)
        # cv2.imshow('YOLOv8', resized_image)
        # cv2.waitKey(0)

        padded_image = cv2.copyMakeBorder(
            resized_image,
            0 + (self.input_width - resized_image.shape[0]) // 2,
            (self.input_width - resized_image.shape[0]) // 2,
            0 + (self.input_height - resized_image.shape[1]) // 2,
            (self.input_height - resized_image.shape[1]) // 2,
            cv2.BORDER_CONSTANT,
            value=[0, 0, 0]
        )

        # cv2.imshow('padded_image', padded_image)
        # cv2.waitKey(0)

        # Convert to blob format
        blob = cv2.dnn.blobFromImage(padded_image, scalefactor=1 / 255.0, size=(self.input_width, self.input_height),
                                     crop=False, swapRB=True)
        # blob_test = (blob[0].transpose((1, 2, 0)) * 255).astype(np.uint8)
        # print(blob.shape)

        # cv2.imshow('blob', blob_test)
        # cv2.waitKey(0)

        # Update scaling factor in the object
        self.scaling_factor = 1 / scaling_factor

        # Return the preprocessed image data
        return blob

    def postprocess(self, output):
        """
        Performs post-processing on the model's output to extract bounding boxes, scores, and class IDs.

        Args:
            output (numpy.ndarray): The output of the model.

        Returns:
            numpy.ndarray: The filtered bounding boxes, scores, and class IDs.
        """
        # Transpose and squeeze the output to match the expected shape
        outputs = np.squeeze(output[0]).T

        # print(output)
        # exit(0)

        # Calculate the maximum scores and corresponding class IDs
        max_scores = np.amax(outputs)
        class_ids = np.argmax(outputs)

        # Apply the confidence threshold
        if max_scores >= self.confidence_thres:
            return max_scores, class_ids
        else:
            return 0, 0

    def main(self):
        """
        Performs inference using an ONNX model and returns the output image with drawn detections.

        Returns:
            output_img: The output image with drawn detections.
        """

        # preprocess_time = time.time()

        # Preprocess the image data
        img_data = self.preprocess()

        # cv2.imshow('YOLOv8', img_data)
        # cv2.waitKey(0)

        # logger.info(f"Preprocess time: {time.time() - preprocess_time:.03f}s")

        # Run inference using the preprocessed image data
        # start_infer_time = time.time()

        outputs = self.session.run(None, {self.session.get_inputs()[0].name: img_data})

        # logger.info(f"Infer time: {time.time() - start_infer_time:.03f}s")

        # Perform post-processing on the outputs to obtain output image.
        # postprocess_time = time.time()

        conf, cls = self.postprocess(outputs)

        # logger.info(f"Postprocess time: {time.time() - postprocess_time:.03f}s")

        return conf, cls  # output image
