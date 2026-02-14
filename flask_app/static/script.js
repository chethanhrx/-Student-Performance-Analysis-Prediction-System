document.getElementById('predictForm').onsubmit = async function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    const response = await fetch('/predict', {
        method: 'POST',
        body: formData
    });
    const data = await response.json();
    const resultDiv = document.getElementById('result');
    if (data.predicted_score !== undefined) {
        resultDiv.textContent = 'Predicted Final Score: ' + data.predicted_score;
    } else {
        resultDiv.textContent = 'Error: ' + (data.error || 'Invalid input');
    }
};