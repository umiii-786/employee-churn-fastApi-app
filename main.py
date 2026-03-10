from fastapi import FastAPI,Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import JSONResponse
import mlflow
import dagshub
import numpy as np
import pickle
from sklearn.compose import ColumnTransformer
import os 
# Setup tracking

dagshub_pat=os.getenv("DAGSHUB_PAT")
if not dagshub_pat:
    raise EnvironmentError('DAGSHUB_PAT environment variable is not setted ') 
os.environ['MLFLOW_TRACKING_USERNAME']=dagshub_pat 
os.environ['MLFLOW_TRACKING_PASSWORD']=dagshub_pat 

mlflow.set_tracking_uri('https://dagshub.com/umiii-786/employee-churn-prediction.mlflow')

app=FastAPI()
template=Jinja2Templates('templates')



run_id = "6f1b78a25771436ebca45eaf3128ef11"
artifact_path = "column_transformer.pkl"

model = mlflow.sklearn.load_model( model_uri="models:/Churn_Model_With_RF/Production")
local_path = mlflow.artifacts.download_artifacts(run_id=run_id,artifact_path=artifact_path,dst_path='./')
print(model)
print("Downloaded to:", local_path)

    


@app.get('/')
def HomePage(request:Request):
    return template.TemplateResponse(request=request,name='index.html')


@app.post("/predict")
async def predict(request: Request):
    print('request ai')
    form = await request.form()

    print(form)
    record=np.array([[
        float(form.get('satisfaction')),
        float(form.get('evaluation')),
        int(form.get('projects')),
        int(form.get('avg_month_hour')),
        int(form.get('tenure')),
        int(form.get('work_accident')),
        int(form.get('promotion')),
        form.get('department'),
        int(form.get('salary'))
      ]])
    

    print(record)

    trf=pickle.load(open('column_transformer.pkl','rb'))
    trf_record=trf.transform(record)
    print(trf_record)

    result=model.predict(trf_record)
    prob=model.predict_proba(trf_record)
    print(result)
    print(prob)

    return JSONResponse({
    "result": int(result[0]),
    "probability": prob[0].tolist()
})