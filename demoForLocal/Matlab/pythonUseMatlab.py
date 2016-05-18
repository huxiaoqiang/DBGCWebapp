from win32com.client import Dispatch
h = Dispatch("Matlab.application")
h.execute("DBGCUseTrainedANN()")