import type {Model} from 'react3l';
import {Repository} from 'react3l';
import type {Observable} from 'rxjs';
import {map} from 'rxjs';
import DevopsProject from 'src/models/DevopsProject';
import type {AxiosRequestConfig, AxiosResponse} from 'axios';
import {DevopsRepository} from 'src/models/DevopsRepository';

class AzureDevopsRepository extends Repository {
  constructor() {
    super();
    this.baseURL = 'https://devops.truesight.asia:8123/DefaultCollection';

    this.http.interceptors.request.use(this.requestInterceptor);
  }

  public readonly projects = (): Observable<DevopsProject[]> => {
    return this.http
      .get('/_apis/projects', {})
      .pipe(this.mapFromDevops<DevopsProject>(DevopsProject));
  };

  public readonly repositories = (
    project: string,
  ): Observable<DevopsRepository[]> => {
    return this.http
      .get(`/${project}/_apis/git/repositories`, {})
      .pipe(this.mapFromDevops<DevopsRepository>(DevopsRepository));
  };

  public readonly files = (project: string, repository: string) => {
    return this.http.get(
      `/${project}/_apis/git/repositories/${repository}/items`,
    );
  };

  private mapFromDevops<T>(TClass: (new () => T) & typeof Model) {
    return map((response: AxiosResponse): T[] =>
      response.data.value.map((project: object) => {
        const obj = TClass.create();
        return Object.assign(obj, project);
      }),
    );
  }

  private readonly requestInterceptor = async (config: AxiosRequestConfig) => {
    if (!config.params) {
      config.params = {};
    }
    config.params = {
      'api-version': '6.0-preview',
    };
    return config;
  };
}

export const azureDevopsRepository: AzureDevopsRepository =
  new AzureDevopsRepository();
