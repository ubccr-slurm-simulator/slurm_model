Each line define an event, the arguments till | define common parameters for event, the arguments after | define event specific arguments

Common parameters:

*  -dt \<dt\> - time to start event in seconds since slurm controller started, it can be fraction, i.e. 1.23

*  -e \<event_type\> - event type, right now only submit_batch_job
  
Parameters for submit_batch_job event:

* -jid  <job_id> this job id will be used to set a job name for cross refferentce later. 
  Because job id is assigned during job submittion it might or might not match the actual job id.
* -sim-walltime <seconds to run> actual job walltime can be fraction.
* The rest are same as for sbatch command
