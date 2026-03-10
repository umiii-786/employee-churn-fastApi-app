import unittest
from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock
import numpy as np

from app import app   # your fastapi file name (change if different)

client = TestClient(app)


class TestFastAPIApp(unittest.TestCase):

    # Test Home Route
    def test_homepage(self):
        response = client.get("/")
        self.assertEqual(response.status_code, 200)


    # Mock ML model and transformer
    @patch("main.pickle.load")
    @patch("main.model")
    def test_predict_endpoint(self, mock_model, mock_pickle):

        # Mock transformer
        mock_transformer = MagicMock()
        mock_transformer.transform.return_value = np.array([[0.5, 0.2, 1]])

        mock_pickle.return_value = mock_transformer

        # Mock model predictions
        mock_model.predict.return_value = np.array([1])
        mock_model.predict_proba.return_value = np.array([[0.2, 0.8]])

        form_data = {
            "satisfaction": "0.5",
            "evaluation": "0.8",
            "projects": "3",
            "avg_month_hour": "160",
            "tenure": "3",
            "work_accident": "0",
            "promotion": "0",
            "department": "sales",
            "salary": "1"
        }

        response = client.post("/predict", data=form_data)

        self.assertEqual(response.status_code, 200)

        data = response.json()

        self.assertEqual(data["result"], 1)
        self.assertEqual(data["probability"], [0.2, 0.8])


if __name__ == "__main__":
    unittest.main()