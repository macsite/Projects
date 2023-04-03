Linear Regression Model for GDP Prediction

This code implements a simple linear regression model to predict GDP based on 5 input features: X1, X2, X3, X4, X5. The model is trained on historical GDP and feature data for multiple years.
Dependencies

    Python 3.6+
    Pandas
    Numpy
    Scikit-learn
    Matplotlib
    Seaborn

Usage

    Clone this repository: git clone https://github.com/macsite/Projects/GDP-LinearRegression
    Navigate to the project directory: cd gdp
    Install the required dependencies: pip install -r requirements.txt
    Run the model script: python gdp.py


Model Details

The linear regression model is implemented using the LinearRegression class from scikit-learn. The model is trained on a dataset containing historical GDP and feature data for multiple years. The training process involves fitting the model to the training data and optimizing the model coefficients to minimize the mean squared error (MSE) between the predicted and actual GDP values.

Once the model is trained, it is evaluated on a separate dataset containing GDP and feature data for a different set of years. The evaluation process involves making predictions using the trained model and computing various performance metrics, including the MSE, mean absolute error (MAE), and R-squared value.

Finally, the model can be used to make GDP predictions for new input data by providing a CSV file containing the feature data in the same format as the training and evaluation datasets. 

This code is licensed under the MIT license. See the LICENSE file for more details.
