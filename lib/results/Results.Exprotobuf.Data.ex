defmodule Results.Exprotobuf.Data do
  use Protobuf, from: Application.app_dir(:results, "priv/results.proto")
end
