import {Model, ObjectField} from 'react3l';
import DevopsProject from './DevopsProject';
import {Field} from 'react3l';

export class DevopsRepository extends Model {
  @Field(String)
  id: string;

  @Field(String)
  name: string;

  @Field(String)
  url: string;

  @ObjectField(DevopsProject)
  project: DevopsProject;

  @Field(String)
  defaultBranch: string;

  @Field(Number)
  size: number;

  @Field(String)
  remoteUrl: string;

  @Field(String)
  sshUrl: string;

  @Field(String)
  webUrl: string;
}
