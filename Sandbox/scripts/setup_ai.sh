num=0
status=1

until [ $num -ge 5 ]
do
  $HOME/anaconda3/bin/pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.0.1-cp36-cp36m-linux_x86_64.whl && status=0 && break
  echo -e 'Re-trying TensorFlow installation...'
  num=$(($num + 1))
  sleep 5
done

if [ $status -eq 0 ]; then
  echo -e 'Cloning Open AI Gym...'
  git clone https://github.com/openai/gym /opt/gym
  echo -e 'Installing Open AI Gym...'
  cd /opt/gym && $HOME/anaconda3/bin/pip install -e .
  echo -e 'Installed Open AI Gym.'
  exit $status
else
  echo -e 'Unable to install TensorFlow.'
  exit $status
fi
