import numpy as np

class ErrorMeasure:
    def __init__(self):
        pass
    
    def calculate_error(self, yobs, y) -> float:
        pass

class EuclideanDistanceError(ErrorMeasure):
    def calculate_error(self, yobs, y) -> float:
        np.sqrt(np.sum((yobs-y)**2))